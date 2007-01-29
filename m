Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbXA2UO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbXA2UO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXA2UO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:14:26 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:37774 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbXA2UOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:14:25 -0500
Subject: Re: question on resume()
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Oliver Neukum <oliver@neukum.name>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200701291234.59706.oliver@neukum.name>
References: <200701291206.39637.oneukum@suse.de>
	 <1170069896.3538.26.camel@nigel.suspend2.net>
	 <200701291234.59706.oliver@neukum.name>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 07:14:20 +1100
Message-Id: <1170101660.15820.18.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-01-29 at 12:34 +0100, Oliver Neukum wrote:
> Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> > Hi.
> > 
> > On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > > Hi,
> > > 
> > > may a driver call wake_up() while doing resume() ?
> > 
> > I assume you mean waking a userspace process from drivers_resume(). If
> > so, the answer is no - processes will still be frozen at the point. In
> > the case of Suspend2, the LRU pages will still not have been read
> > either, so Suspend2 users would hate you for making hibernation crash
> > and burn :)
> 
> If so, how do I notify tasks presumably about to be thawed that their
> IO failed?

Do you mean I/O to disk? If so, it won't fail. All pending I/O gets
processed like normal either before or after suspending and resuming.

If you mean something like a packet being transmitted over the network,
you should be using the normal paths for recording success/failure.

HTH.

Nigel

