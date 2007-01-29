Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbXA2VVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbXA2VVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXA2VVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:21:10 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:43737 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXA2VVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:21:09 -0500
Subject: Re: question on resume()
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200701292204.33112.oliver@neukum.org>
References: <200701291206.39637.oneukum@suse.de>
	 <200701291234.59706.oliver@neukum.name>
	 <1170101660.15820.18.camel@nigel.suspend2.net>
	 <200701292204.33112.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 08:21:04 +1100
Message-Id: <1170105665.15820.29.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-01-29 at 22:04 +0100, Oliver Neukum wrote:
> Am Montag, 29. Januar 2007 21:14 schrieb Nigel Cunningham:
> > Hi.
> > 
> > On Mon, 2007-01-29 at 12:34 +0100, Oliver Neukum wrote:
> > > Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> > > > Hi.
> > > > 
> > > > On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > > > > Hi,
> > > > > 
> > > > > may a driver call wake_up() while doing resume() ?
> > > > 
> > > > I assume you mean waking a userspace process from drivers_resume(). If
> > > > so, the answer is no - processes will still be frozen at the point. In
> > > > the case of Suspend2, the LRU pages will still not have been read
> > > > either, so Suspend2 users would hate you for making hibernation crash
> > > > and burn :)
> > > 
> > > If so, how do I notify tasks presumably about to be thawed that their
> > > IO failed?
> > 
> > Do you mean I/O to disk? If so, it won't fail. All pending I/O gets
> > processed like normal either before or after suspending and resuming.
> > 
> > If you mean something like a packet being transmitted over the network,
> > you should be using the normal paths for recording success/failure.
> 
> I am talking about a character device that puts requests onto a queue.
> If the queue is restarted after resumption the normal error path is waking
> up the waiting tasks.

Ok. In that case, you'd want to delay trying to wake them until resuming
is completed.

Unless there's something I've forgotten, we don't currently have an easy
way for you to determine when processes are thawed. Perhaps this
indicates a need for us to have a notifier chain for the end of a cycle?
You could create a freezeable workqueue and schedule work from your
device_resume call (assuming that's doesn't raised atomicity issues),
but I wonder if that approach would be too heavy handed for what you're
after. I'll explicitly cc Rafael and see what he thinks.

Regards,

Nigel

