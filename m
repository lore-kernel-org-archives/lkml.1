Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbZJNBkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbZJNBkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZJNBkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:40:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34025 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZJNBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:40:04 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=sFIEXyL5ArgA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=zqyaO31he40B6vAakqIA:9 a=Q4vVD2HBrhG5WQLKlEoA:7
 a=x4ttBs-z_YhqmhHqd4EvtfYNWZoA:4 a=U62fhAwekXMA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Tue, 13 Oct 2009 19:39:08 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
Cc: linux-raid@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>, kewei@marvell.com
References: <200910091141.52303.tfjellstrom@shaw.ca> <4AD22532.9060001@univ-lille2.fr> <200910111658.13639.tfjellstrom@shaw.ca>
In-Reply-To: <200910111658.13639.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910131939.09039.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun October 11 2009, Thomas Fjellstrom wrote:
> On Sun October 11 2009, Christian Vilhelm wrote:
> > Thomas Fjellstrom wrote:
> > > Hi,
> > >
> > > I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card)
> > > to work with linux for the past month or so. I've recently just RMAed
> > > my first card, and tested the new one under linux, and I see the same
> > > problems.
> > >
> > > The very first time I made a new array off the controller, formated
> > > (with xfs) and mounted the volume, it seemed to work. ioozone even
> > > seemed to run for a while. Sadly after a few minutes I got a stream of
> > > mvs_abort_task messages in dmesg, and any accesses to the volume, or
> > > any disks connected to the controller lock up.
> > >
> > > After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of
> > > kernel.org, and the volume fails to mount with the same mvs_abort_task
> > > messages.
> >
> > I have the exact same problem with another Marvell 88SE64xx based card,
> > namely an Areca ARC-1300ix-16 and the mvsas driver.
> > If the disks are just used alone, with a filesystem on them, all seems
> > to work fine. dd and badblocks run fine on them. Mounting them,
> > reading/writing work fine. The error seem to popup but rarely when
> > several disks are used simultaneously.
> > But, an absolute sure way to trigger the error is to assemble (or
> > create) a md raid array with the disks. I join a syslog extract from the
> > error. You can see it happens seconds after the array creation.
> > I tried :
> > 1) disabling the write cache on the disks => same error
> > 2) disabling NCQ : in mv_sas.h :
> > #define MV_DISABLE_NCQ  1
> > same error.
> > Afer a while, the devices handled by the card are just dropped from the
> > system and the card stops working at all, a reboot is necessary.
> 
> I have found that a proper reboot is impossible once the card/driver starts
> misbehaving. Anything that tries to do anything with the md device, or any
>  of the component drives will hang. Even kernel threads it seems. A reboot
>  or a shutdown hangs when it tries to sync the md device, and ALT+SYSRQ+S/U
>  both hang. After the first Alt+sysrq+s it will register more of them, but
>  it won't print the "Emergency Sync Complete" message.
> 
> > Does anyone have a working config based on a Marvell 64xx card ?
> >
> > I'm willing to explore solutions, patches or anything, just tell me what
> > to do to help.
> >
> > Christian Vilhelm.
> 

I'd really appreciate some assistance with this. The card is essentially 
useless under linux, if not harmful (causes oopses and hangs) with the current 
driver.

My last weekly backup failed while creating the disk image due to my array 
being low on space, I really need to get the new array up asap.

Thanks.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
