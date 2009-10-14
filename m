Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZJNHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZJNHTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZJNHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:19:38 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19473 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbZJNHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:19:37 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=sFIEXyL5ArgA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=dW_fms3SFiZasfwmYoIA:9 a=SKRpyKWeFzXKWWNgDdgA:7
 a=KEvRcP_7TsIuM2zkPPlo3pHkszkA:4 a=x8gzFH9gYPwA:10 a=U62fhAwekXMA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: andy yan <andyysj@gmail.com>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Wed, 14 Oct 2009 01:18:39 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>, kewei@marvell.com
References: <200910091141.52303.tfjellstrom@shaw.ca> <200910131939.09039.tfjellstrom@shaw.ca> <e938503f0910132151p20b42459v96800d889f3f63eb@mail.gmail.com>
In-Reply-To: <e938503f0910132151p20b42459v96800d889f3f63eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910140118.39988.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue October 13 2009, andy yan wrote:
> I will send you a patch for debugging this issue, please help to try and
> send back the log, thanks!

I will do whatever I can to help get this resolved :) I have some C skills, 
but no kernel/device driver experience, so at the very least I should be able 
to do builds and make small changes if needed, in addition to patching and 
endless reboots ;D

> On Wed, Oct 14, 2009 at 9:39 AM, Thomas Fjellstrom 
<tfjellstrom@shaw.ca>wrote:
> > On Sun October 11 2009, Thomas Fjellstrom wrote:
> > > On Sun October 11 2009, Christian Vilhelm wrote:
> > > > Thomas Fjellstrom wrote:
> > > > > Hi,
> > > > >
> > > > > I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS
> >
> > card)
> >
> > > > > to work with linux for the past month or so. I've recently just
> > > > > RMAed my first card, and tested the new one under linux, and I see
> > > > > the same problems.
> > > > >
> > > > > The very first time I made a new array off the controller, formated
> > > > > (with xfs) and mounted the volume, it seemed to work. ioozone even
> > > > > seemed to run for a while. Sadly after a few minutes I got a stream
> >
> > of
> >
> > > > > mvs_abort_task messages in dmesg, and any accesses to the volume,
> > > > > or any disks connected to the controller lock up.
> > > > >
> > > > > After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of
> > > > > kernel.org, and the volume fails to mount with the same
> >
> > mvs_abort_task
> >
> > > > > messages.
> > > >
> > > > I have the exact same problem with another Marvell 88SE64xx based
> > > > card, namely an Areca ARC-1300ix-16 and the mvsas driver.
> > > > If the disks are just used alone, with a filesystem on them, all
> > > > seems to work fine. dd and badblocks run fine on them. Mounting them,
> > > > reading/writing work fine. The error seem to popup but rarely when
> > > > several disks are used simultaneously.
> > > > But, an absolute sure way to trigger the error is to assemble (or
> > > > create) a md raid array with the disks. I join a syslog extract from
> >
> > the
> >
> > > > error. You can see it happens seconds after the array creation.
> > > > I tried :
> > > > 1) disabling the write cache on the disks => same error
> > > > 2) disabling NCQ : in mv_sas.h :
> > > > #define MV_DISABLE_NCQ  1
> > > > same error.
> > > > Afer a while, the devices handled by the card are just dropped from
> > > > the system and the card stops working at all, a reboot is necessary.
> > >
> > > I have found that a proper reboot is impossible once the card/driver
> >
> > starts
> >
> > > misbehaving. Anything that tries to do anything with the md device, or
> >
> > any
> >
> > >  of the component drives will hang. Even kernel threads it seems. A
> >
> > reboot
> >
> > >  or a shutdown hangs when it tries to sync the md device, and
> >
> > ALT+SYSRQ+S/U
> >
> > >  both hang. After the first Alt+sysrq+s it will register more of them,
> >
> > but
> >
> > >  it won't print the "Emergency Sync Complete" message.
> > >
> > > > Does anyone have a working config based on a Marvell 64xx card ?
> > > >
> > > > I'm willing to explore solutions, patches or anything, just tell me
> >
> > what
> >
> > > > to do to help.
> > > >
> > > > Christian Vilhelm.
> >
> > I'd really appreciate some assistance with this. The card is essentially
> > useless under linux, if not harmful (causes oopses and hangs) with the
> > current
> > driver.
> >
> > My last weekly backup failed while creating the disk image due to my
> > array being low on space, I really need to get the new array up asap.
> >
> > Thanks.
> >
> > --
> > Thomas Fjellstrom
> > tfjellstrom@shaw.ca
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
