Return-Path: <linux-kernel-owner+w=401wt.eu-S964830AbXA2XKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbXA2XKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964852AbXA2XKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:10:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830AbXA2XKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:10:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: question on resume()
Date: Tue, 30 Jan 2007 00:10:37 +0100
User-Agent: KMail/1.9.1
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
References: <200701291206.39637.oneukum@suse.de> <200701292204.33112.oliver@neukum.org> <1170105665.15820.29.camel@nigel.suspend2.net>
In-Reply-To: <1170105665.15820.29.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701300010.38538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 29 January 2007 22:21, Nigel Cunningham wrote:
> Hi.
> 
> On Mon, 2007-01-29 at 22:04 +0100, Oliver Neukum wrote:
> > Am Montag, 29. Januar 2007 21:14 schrieb Nigel Cunningham:
> > > Hi.
> > > 
> > > On Mon, 2007-01-29 at 12:34 +0100, Oliver Neukum wrote:
> > > > Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> > > > > Hi.
> > > > > 
> > > > > On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > may a driver call wake_up() while doing resume() ?
> > > > > 
> > > > > I assume you mean waking a userspace process from drivers_resume(). If
> > > > > so, the answer is no - processes will still be frozen at the point. In
> > > > > the case of Suspend2, the LRU pages will still not have been read
> > > > > either, so Suspend2 users would hate you for making hibernation crash
> > > > > and burn :)
> > > > 
> > > > If so, how do I notify tasks presumably about to be thawed that their
> > > > IO failed?
> > > 
> > > Do you mean I/O to disk? If so, it won't fail. All pending I/O gets
> > > processed like normal either before or after suspending and resuming.
> > > 
> > > If you mean something like a packet being transmitted over the network,
> > > you should be using the normal paths for recording success/failure.
> > 
> > I am talking about a character device that puts requests onto a queue.
> > If the queue is restarted after resumption the normal error path is waking
> > up the waiting tasks.
> 
> Ok. In that case, you'd want to delay trying to wake them until resuming
> is completed.
> 
> Unless there's something I've forgotten, we don't currently have an easy
> way for you to determine when processes are thawed.

That's correct.

> Perhaps this indicates a need for us to have a notifier chain for the end of
> a cycle?

Probably.  Well, I have no strong opinion about that.
 
> You could create a freezeable workqueue and schedule work from your
> device_resume call (assuming that's doesn't raised atomicity issues),
> but I wonder if that approach would be too heavy handed for what you're
> after. I'll explicitly cc Rafael and see what he thinks.

Hm, this way or another, the notification of tasks should be deferred until
they are thawed.  The freezeable workqueue idea seems sensible to me.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
