Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbXFUDCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbXFUDCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXFUDCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:02:00 -0400
Received: from mail.suse.de ([195.135.220.2]:37799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXFUDB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:01:59 -0400
From: Neil Brown <neilb@suse.de>
To: David Greaves <david@dgreaves.com>
Date: Thu, 21 Jun 2007 13:01:44 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18041.59928.812167.453118@notabene.brown>
Cc: Wakko Warner <wakko@animx.eu.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from David Greaves on Saturday June 16
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<20070616020320.GB2002@animx.eu.org>
	<18035.23867.576212.859440@notabene.brown>
	<4673E69A.4020309@dgreaves.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday June 16, david@dgreaves.com wrote:
> Neil Brown wrote:
> > On Friday June 15, wakko@animx.eu.org wrote:
> >  
> >>                                                   As I understand the way
> >> raid works, when you write a block to the array, it will have to read all
> >> the other blocks in the stripe and recalculate the parity and write it out.
> > 
> > Your understanding is incomplete.
> 
> Does this help?
> [for future reference so you can paste a url and save the typing for code :) ]
> 
> http://linux-raid.osdl.org/index.php/Initial_Array_Creation
> 
> David
> 
> 
> 
> Initial Creation
> 
> When mdadm asks the kernel to create a raid array the most noticeable activity 
> is what's called the "initial resync".
> 
> The kernel takes one (or two for raid6) disks and marks them as 'spare'; it then 
> creates the array in degraded mode. It then marks spare disks as 'rebuilding' 
> and starts to read from the 'good' disks, calculate the parity and determines 
> what should be on any spare disks and then writes it. Once all this is done the 
> array is clean and all disks are active.

This isn't quite right.
Firstly, it is mdadm which decided to make one drive a 'spare' for
raid5, not the kernel.
Secondly, it only applies to raid5, not raid6 or raid1 or raid10.

For raid6, the initial resync (just like the resync after an unclean
shutdown) reads all the data blocks, and writes all the P and Q
blocks.
raid5 can do that, but it is faster the read all but one disk, and
write to that one disk.

NeilBrown
