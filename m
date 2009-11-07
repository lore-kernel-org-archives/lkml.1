Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZKGWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZKGWWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZKGWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:22:38 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:37672 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZKGWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:22:37 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=a4SXKOyBHiMA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=6cGOuOqAFvJEg7fR8cwA:9 a=EBPn2G4BxzYj1zIvxoL9YzWMFcUA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed s2disk/ram cycle
Date: Sat, 7 Nov 2009 15:22:41 -0700
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-amd64; KDE/4.3.2; x86_64; ; )
References: <87vdisq7bh.fsf@rimspace.net> <20091104111125.54C3.A69D9226@jp.fujitsu.com> <20091105095637.GG30649@khazad-dum.debian.net>
In-Reply-To: <20091105095637.GG30649@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911071522.41645.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 5 2009, Henrique de Moraes Holschuh wrote:
> On Wed, 04 Nov 2009, KOSAKI Motohiro wrote:
> > > On Wed, Oct 07, 2009 at 01:14:10PM +1100, Daniel Pittman wrote:
> > > > For what it is worth, I would also be quite interested to know
> > > > /why/ XFS is bad in this regard.  Is it just the previously stated
> > > > "XFS writes to disk despite freezing kernel threads" issue, or
> > > > something deeper?
> > >
> > > sync pushes out all data to disk, but in a journaling filesystem that
> > > might just but the log not the "normal" place on disk.  For a boot
> > > loader to deal with it properly it actually needs to do an replay of
> > > the log.  Grub does so for reiserfs but not for XFS for some reason.
> > > I don't know why problems don't trigger more often with ext3, though.
> >
> > I'm sorry for the long delayed and offtopic responce. I discussed this
> > issue with okuji-san (GRUB2 maintainer) at several month ago.
> > He really wish linux implement real sync.
> 
> This is not about real sync.  It is about the box being able to reboot
>  after a crash or power failure.
> 
> GRUB2 is broken in that regard, at least in its peecee-BIOS version: 
>  last time I checked, it doesn't sort RAID components so that it won't
>  boot from failed or out-of-sync older components, it can't deal with
>  some of the filesystems being unclean...
> 
> > A bootloader has much constraint than OS (mainly caused by size
> > constraint). it can't implemnt jornal log replay logic for _all_
> > filesystem. Why can't we implement storong sync syscall? I don't think
> > this is PM nor bootloader fault.
> 
> A bootloader that can't boot a system that went through an unclean
>  shutdown is quite broken.
> 

It can barely boot a system that's gone through a clean shutdown. "bios read 
error" and all that.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
