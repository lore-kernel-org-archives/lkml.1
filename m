Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYBOVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYBOVcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYBOVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:32:24 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:35234 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYBOVcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:32:24 -0500
Date: Fri, 15 Feb 2008 22:32:24 +0100
From: FD Cami <francois.cami@free.fr>
To: Zan Lynx <zlynx@acm.org>
Cc: Prakash Punnoor <prakash@punnoor.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org,
       megaraidlinux@lsi.com
Subject: Re: Disk schedulers
Message-ID: <20080215223224.50102e0a@olorin>
In-Reply-To: <1203095486.6663.12.camel@localhost>
References: <20080214162104.GA5347@ics.muni.cz>
	<Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
	<200802151557.59082.prakash@punnoor.de>
	<1203095486.6663.12.camel@localhost>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 10:11:26 -0700
Zan Lynx <zlynx@acm.org> wrote:

> 
> On Fri, 2008-02-15 at 15:57 +0100, Prakash Punnoor wrote:
> > On the day of Friday 15 February 2008 Jan Engelhardt hast written:
> > > On Feb 14 2008 17:21, Lukas Hejtmanek wrote:
> > > >Hello,
> > > >
> > > >whom should I blame about disk schedulers?
> > >
> > > Also consider
> > > - DMA (e.g. only UDMA2 selected)
> > > - aging disk
> > 
> > Nope, I also reported this problem _years_ ago, but till now much hasn't 
> > changed. Large writes lead to read starvation.
> 
> Yes, I see this often myself.  It's like the disk IO queue (I set mine
> to 1024) fills up, and pdflush and friends can stuff write requests into
> it much more quickly than any other programs can provide read requests.
> 
> CFQ and ionice work very well up until iostat shows average IO queuing
> above 1024 (where I set the queue number).

I can confirm that as well.

This is easily reproductible with dd if=/dev/zero of=somefile bs=2048
for example. After a short while, trying to read the disks takes an
awfully long time, even if the dd process is ionice'd.

What is worse is that other drives attached to the same controller become
unresponsive as well.
I use a Dell Perc 5/i (megaraid_sas) with :
* 2 SAS 15000 RPM drives, RAID1 => sda
* 4 SAS 15000 RPM drives, RAID5 => sdb
* 2 SATA 72000 RPM drives, RAID1 => sdc
Using dd or mkfs on sdb or sdc makes sda unresponsive as well.
Is this expected ?

Cheers

Francois
