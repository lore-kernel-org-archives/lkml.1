Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXA3QcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXA3QcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXA3QcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:32:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965565AbXA3QcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:32:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: question on resume()
Date: Tue, 30 Jan 2007 17:32:55 +0100
User-Agent: KMail/1.9.1
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
References: <200701291206.39637.oneukum@suse.de> <1170105665.15820.29.camel@nigel.suspend2.net> <200701300010.38538.rjw@sisk.pl>
In-Reply-To: <200701300010.38538.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301732.56444.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 January 2007 00:10, Rafael J. Wysocki wrote:
> Hi,
> 
> On Monday, 29 January 2007 22:21, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Mon, 2007-01-29 at 22:04 +0100, Oliver Neukum wrote:
> > > Am Montag, 29. Januar 2007 21:14 schrieb Nigel Cunningham:
> > > > Hi.
> > > > 
> > > > On Mon, 2007-01-29 at 12:34 +0100, Oliver Neukum wrote:
> > > > > Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> > > > > > Hi.
> > > > > > 
> > > > > > On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > may a driver call wake_up() while doing resume() ?
> > > > > > 
> > > > > > I assume you mean waking a userspace process from drivers_resume(). If
> > > > > > so, the answer is no - processes will still be frozen at the point. In
> > > > > > the case of Suspend2, the LRU pages will still not have been read
> > > > > > either, so Suspend2 users would hate you for making hibernation crash
> > > > > > and burn :)
> > > > > 
> > > > > If so, how do I notify tasks presumably about to be thawed that their
> > > > > IO failed?
> > > > 
> > > > Do you mean I/O to disk? If so, it won't fail. All pending I/O gets
> > > > processed like normal either before or after suspending and resuming.
> > > > 
> > > > If you mean something like a packet being transmitted over the network,
> > > > you should be using the normal paths for recording success/failure.
> > > 
> > > I am talking about a character device that puts requests onto a queue.
> > > If the queue is restarted after resumption the normal error path is waking
> > > up the waiting tasks.
> > 
> > Ok. In that case, you'd want to delay trying to wake them until resuming
> > is completed.
> > 
> > Unless there's something I've forgotten, we don't currently have an easy
> > way for you to determine when processes are thawed.
> 
> That's correct.

However, you can always inspect the PF_FROZEN flag of the tasks in question
if that's practicable.

So, while we do not have a mechanism for checking if all tasks have been
thawed, we can do it on a per-task basis quite easily.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
