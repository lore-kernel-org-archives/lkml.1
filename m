Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXA2VDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXA2VDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXA2VDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:03:43 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:44639 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbXA2VDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:03:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: nigel@nigel.suspend2.net
Subject: Re: question on resume()
Date: Mon, 29 Jan 2007 22:04:32 +0100
User-Agent: KMail/1.8
Cc: linux-kernel@vger.kernel.org
References: <200701291206.39637.oneukum@suse.de> <200701291234.59706.oliver@neukum.name> <1170101660.15820.18.camel@nigel.suspend2.net>
In-Reply-To: <1170101660.15820.18.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701292204.33112.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Januar 2007 21:14 schrieb Nigel Cunningham:
> Hi.
> 
> On Mon, 2007-01-29 at 12:34 +0100, Oliver Neukum wrote:
> > Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> > > Hi.
> > > 
> > > On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > > > Hi,
> > > > 
> > > > may a driver call wake_up() while doing resume() ?
> > > 
> > > I assume you mean waking a userspace process from drivers_resume(). If
> > > so, the answer is no - processes will still be frozen at the point. In
> > > the case of Suspend2, the LRU pages will still not have been read
> > > either, so Suspend2 users would hate you for making hibernation crash
> > > and burn :)
> > 
> > If so, how do I notify tasks presumably about to be thawed that their
> > IO failed?
> 
> Do you mean I/O to disk? If so, it won't fail. All pending I/O gets
> processed like normal either before or after suspending and resuming.
> 
> If you mean something like a packet being transmitted over the network,
> you should be using the normal paths for recording success/failure.

I am talking about a character device that puts requests onto a queue.
If the queue is restarted after resumption the normal error path is waking
up the waiting tasks.

	Regards
		Oliver
