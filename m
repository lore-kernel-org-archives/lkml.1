Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab0CKRrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:47:08 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:49252 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0CKRrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:47:06 -0500
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 12:47:06 EST
Date: Thu, 11 Mar 2010 18:36:04 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Mathias Buren <mathias.buren@ie.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RAID + LUKS + LVM performance
Message-ID: <20100311173604.GA17659@citd.de>
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.03.2010 13:08, Mathias Buren wrote:
> 
> Hi,
> 
> (please cc me as I'm not subscribed)
> 
> I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
> HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
> http://www.areca.com.tw/products/pcie.htm ) etc.
> The plan is create a RAID5 array spanning all the disks, then create 4
> partitions. These 4 partitions would be encrypted using LUKS (Twofish or
> AES256).
> These 4 encrypted partition would be set up in RAID0 using Linux' software
> (mdadm), then LVM would be used on top of that (one big PV, one big VG and
> a big LV or so).
> 
> The reason for this is that kcryptd is not multithreaded (afaik). By having
> 4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
> processes to run on all four cpu cores whenever something is written to the
> disks, which should improve (encryption) performance.
> 
> Is this a good way of doing it, or is there a smarter way?

The setup you describe would only work with SSDs. HDDs would seek 
themselves to death.

The problem is the RAID-0 over the 4 partitions. At that point you would 
need, instead of the 4 partitions, something that is round-robin. So 
that the mapping of the (physical) blocks from the upper to the lower 
would be effectivly linear/unchanged.

AFAIK something like that is (currently) not possible.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

