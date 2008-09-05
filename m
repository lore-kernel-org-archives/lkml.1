Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYIEPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYIEPP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYIEPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:15:15 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33100 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYIEPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:15:14 -0400
Subject: Re: [PATCH 0/6] detect online disk resize
From: Andrew Patterson <andrew.patterson@hp.com>
To: Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
In-Reply-To: <20080905082110.GN13941@edu.joroinen.fi>
References: <20080904202714.10456.88061.stgit@bob.kio>
	 <20080905082110.GN13941@edu.joroinen.fi>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Sep 2008 09:15:10 -0600
Message-Id: <1220627710.7790.17.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 11:21 +0300, Pasi Kärkkäinen wrote:
> > 1. For SCSI devices do:
> > 
> >   # echo 1 > /sys/class/scsi_device/<device>/device/rescan
> > 
> >   or
> > 
> >   # blockdev --rereadpt <device file>
> > 
> > 2. Other devices (not device mapper)
> > 
> >   # blockdev --rereadpt <device file>
> > 
> > I have tested this patch on SCSI and SmartArray (cciss)
> > devices. Device mapper still does not recognize device size changes
> > until the device is restarted.
> > 
> 
> Hello and thanks for the patch! 
> 
> How about device mapper.. what's needed to make it detect/support online resizes?
> I'm specificly interested in online resizing (growing) dm-multipath devices.. 
> 

Yes, it would be nice if this patchset worked here too. It currently
does not. 

> Basicly I'd like to have LVM PV on dm-multipath device.. so first I need to
> get the actual disks resized, then dm-multipath device, and finally run pvresize.
> 

I did some testing with multipath here.  I could get it working by
shutting down the devices, resizing all the underlying paths using the
above methods, restarting the devices, then running pvresize. This
method does not help much given that most users cannot realistically
shutdown a device. This patch series works fine with standard LVM/dm,
i.e., resize using one of the above methods, then run pvresize.

I was planning on looking into dm-multipath in the near future.  Mike
Anderson has done some work in this area in the past.

> I know dm-multipath part can be done atm using this (hacky) method:
> https://www.redhat.com/archives/dm-devel/2008-August/msg00033.html
> 

This is indeed ugly.  It looks like they are pulling the paths out of
the device, resizing them, and then adding them back in.

> -- Pasi


