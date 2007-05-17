Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXEQCHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXEQCHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXEQCHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:07:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbXEQCHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:07:46 -0400
From: Neil Brown <neilb@suse.de>
To: koan <koan00@gmail.com>
Date: Thu, 17 May 2007 12:07:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17995.47339.651121.146258@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20.11] File system corruption with degraded md/RAID-5 device
In-Reply-To: message from koan on Wednesday May 16
References: <64d833020705161326m51922f63n31ef5b528a514ed7@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday May 16, koan00@gmail.com wrote:
> 
> Here is what I am doing to test:
> 
> fdisk /dev/sda1 and /dev/sb1 to type fd/Linux raid auto
> mdadm --create /dev/md1 -c 128 -l 5 -n 3 /dev/sda1 /dev/sdb1 missing
> mke2fs -j -b 4096 -R stride=32 /dev/md1
> e2fsck -f /dev/md1
> ---------------------
> Result: FAILS - fsck errors (Example: "Inode 3930855 is in use, but
> has dtime set.")

Very odd.  I cannot reproduce this, but then my drives are somewhat
smaller than yours (though I'm not sure how that could be
significant).

Can you try a raid0 across 2 drives?  That would be more like the
raid5 layout than raid1.

My guess is some subtle hardware problem,  as I would be very
surprised in the raid5 code is causing this.  Maybe run memtest86? 

NeilBrown
