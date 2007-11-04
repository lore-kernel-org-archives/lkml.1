Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXKDIaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXKDIaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 03:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXKDIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 03:30:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:50830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbXKDIan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 03:30:43 -0500
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Bill Nottingham <notting@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200711040120.12640.dtor@insightbb.com>
References: <46B8C8FA.9020100@redhat.com>
	 <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
	 <20070808193220.GB5001@nostromo.devel.redhat.com>
	 <200711040120.12640.dtor@insightbb.com>
Content-Type: text/plain
Date: Sun, 04 Nov 2007 09:30:43 +0100
Message-Id: <1194165043.2132.5.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+S9CpzNb3qZx7AHksttIgHxzK1OzYckkGqeXV
 YhGLeH+Pw2BdnCbM67+I9LwFwcdjTQ92fpZ8qzs/txeODqZ3qx
 ttlFd/eAI48/3ZivXUY0CAg0Zu50u8p
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-11-04 at 01:20 -0400, Dmitry Torokhov wrote:
> On Wednesday 08 August 2007 15:32, Bill Nottingham wrote:
> > Kay Sievers (kay.sievers@vrfy.org) said: 
> > > It doesn't have any aliases, so seems it was never autoloaded.
> > 
> > It was - prior kernels loaded it via the uevent generated from 
> > /devices/platform/pcspkr. Newer kernels seem to never actually
> > trigger a uevent from that (tested with a combination of
> > udevmonitor and 'udevtrigger --subsystem-match=platform'.)
> > 
> 
> The patch below should restore generation of uevents for pcspkr devices.
> Since devices are not created in pcspkr module but rather in arch setup
> code it is right (and safe) thing to do.

This is not needed. The global disablement of platform device creation
events has been reverted in 2.6.24, it broke more than pcsprkr, and
modules that should be auto-loaded just get an alias as usual:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=43cc71eed1250755986da4c0f9898f9a635cb3bf

Thanks,
Kay

