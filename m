Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0CLIoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:44:10 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:56302 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0CLIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:44:08 -0500
In-Reply-To: <20100311173604.GA17659@citd.de>
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com> <20100311173604.GA17659@citd.de>
Subject: Re: RAID + LUKS + LVM performance
X-KeepSent: DBA54FBA:FB6F3D10-802576E4:002FCA7A;
 type=4; name=$KeepSent
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.0.2 HF623 January 16, 2009
Message-ID: <OFDBA54FBA.FB6F3D10-ON802576E4.002FCA7A-802576E4.002FFBCF@ie.ibm.com>
From: Mathias Buren <mathias.buren@ie.ibm.com>
Date: Fri, 12 Mar 2010 08:47:21 +0000
X-MIMETrack: Serialize by Router on D06ML902/06/M/IBM(Release 8.0.1|February 07, 2008) at
 12/03/2010 08:47:22
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer <ms@citd.de> wrote on 2010-03-11 17:36:04:

> Re: RAID + LUKS + LVM performance
>
> Matthias Schniedermeyer
>
> to:
>
> Mathias Buren
>
> 2010-03-11 17:39
>
> Cc:
>
> linux-kernel
>
> On 11.03.2010 13:08, Mathias Buren wrote:
> >
> > Hi,
> >
> > (please cc me as I'm not subscribed)
> >
> > I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
> > HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
> > http://www.areca.com.tw/products/pcie.htm ) etc.
> > The plan is create a RAID5 array spanning all the disks, then create 4
> > partitions. These 4 partitions would be encrypted using LUKS (Twofish
or
> > AES256).
> > These 4 encrypted partition would be set up in RAID0 using Linux'
software
> > (mdadm), then LVM would be used on top of that (one big PV, one big VG
and
> > a big LV or so).
> >
> > The reason for this is that kcryptd is not multithreaded (afaik). By
having
> > 4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
> > processes to run on all four cpu cores whenever something is written to
the
> > disks, which should improve (encryption) performance.
> >
> > Is this a good way of doing it, or is there a smarter way?
>
> The setup you describe would only work with SSDs. HDDs would seek
> themselves to death.
>
> The problem is the RAID-0 over the 4 partitions. At that point you would
> need, instead of the 4 partitions, something that is round-robin. So
> that the mapping of the (physical) blocks from the upper to the lower
> would be effectivly linear/unchanged.
>
> AFAIK something like that is (currently) not possible.
>
>
>
>
>
> Bis denn
>
> --
> Real Programmers consider "what you see is what you get" to be just as
> bad a concept in Text Editors as it is in women. No, the Real Programmer
> wants a "you asked for it, you got it" text editor -- complicated,
> cryptic, powerful, unforgiving, dangerous.
>

Hm. But I thought, since the hw RAID card does its own RAID5 thing on the
harddrives, that they wouldn't seek themselves do death. Perhaps they
would, anyway...

What's the best way to set this up then? Or will kcryptd be able to
encrypt/decrypt everything fast enough anyway (~>5-600MB/s I'd say)?

Mathias

