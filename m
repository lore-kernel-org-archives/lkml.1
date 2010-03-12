Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0CLMG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 07:06:59 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:40137 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab0CLMG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:06:58 -0500
Date: Fri, 12 Mar 2010 13:06:43 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Mathias Buren <mathias.buren@ie.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RAID + LUKS + LVM performance
Message-ID: <20100312120643.GA26020@citd.de>
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com> <20100311173604.GA17659@citd.de> <OFDBA54FBA.FB6F3D10-ON802576E4.002FCA7A-802576E4.002FFBCF@ie.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFDBA54FBA.FB6F3D10-ON802576E4.002FCA7A-802576E4.002FFBCF@ie.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.03.2010 08:47, Mathias Buren wrote:
> Matthias Schniedermeyer <ms@citd.de> wrote on 2010-03-11 17:36:04:
> 
> > Re: RAID + LUKS + LVM performance
> >
> > Matthias Schniedermeyer
> >
> > to:
> >
> > Mathias Buren
> >
> > 2010-03-11 17:39
> >
> > Cc:
> >
> > linux-kernel
> >
> > On 11.03.2010 13:08, Mathias Buren wrote:
> > >
> > > Hi,
> > >
> > > (please cc me as I'm not subscribed)
> > >
> > > I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
> > > HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
> > > http://www.areca.com.tw/products/pcie.htm ) etc.
> > > The plan is create a RAID5 array spanning all the disks, then create 4
> > > partitions. These 4 partitions would be encrypted using LUKS (Twofish
> or
> > > AES256).
> > > These 4 encrypted partition would be set up in RAID0 using Linux'
> software
> > > (mdadm), then LVM would be used on top of that (one big PV, one big VG
> and
> > > a big LV or so).
> > >
> > > The reason for this is that kcryptd is not multithreaded (afaik). By
> having
> > > 4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
> > > processes to run on all four cpu cores whenever something is written to
> the
> > > disks, which should improve (encryption) performance.
> > >
> > > Is this a good way of doing it, or is there a smarter way?
> >
> > The setup you describe would only work with SSDs. HDDs would seek
> > themselves to death.
> >
> > The problem is the RAID-0 over the 4 partitions. At that point you would
> > need, instead of the 4 partitions, something that is round-robin. So
> > that the mapping of the (physical) blocks from the upper to the lower
> > would be effectivly linear/unchanged.
> >
> > AFAIK something like that is (currently) not possible.
> 
> Hm. But I thought, since the hw RAID card does its own RAID5 thing on the
> harddrives, that they wouldn't seek themselves do death. Perhaps they
> would, anyway...
> 
> What's the best way to set this up then? Or will kcryptd be able to
> encrypt/decrypt everything fast enough anyway (~>5-600MB/s I'd say)?

Personally i have only experience with loop-aes (which has the exact 
same problem) and with AES128 i reach a top-speed of about 130MB/s on my 
Core i7-860 for a single thread (tested with a SSD).

Using one of the Westmere Core i5-6XX, which support AES-NI, should get 
you better performance (if supported by krcyptd), altough you loose 2 
cores as onyl have 2. But i don't know what kind of performance 
improvement (if any) AES-NI provides.
Or you wait a few weeks and buy on Core I7-980X with 6 core and AES-NI.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

