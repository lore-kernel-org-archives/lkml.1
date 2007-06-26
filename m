Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbXFZDjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbXFZDjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXFZDjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:39:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:51106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbXFZDjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:39:08 -0400
From: Neil Brown <neilb@suse.de>
To: Graeme Sheppard <nodes@rillion.net>
Date: Tue, 26 Jun 2007 13:38:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18048.35410.896207.686311@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
In-Reply-To: message from Graeme Sheppard on Tuesday June 26
References: <46803772.7020408@rillion.net>
	<46806CCB.6020708@rillion.net>
	<18048.30679.872740.744997@notabene.brown>
	<468085E9.70804@rillion.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 26, nodes@rillion.net wrote:
> Neil Brown wrote:
> > 
> > Sounds a lot like "RAIF" - ask google for details.
> 
> I did not know about RAIF. RAIF "merges" separate filesystems? That is a
> good idea in itself.
> 
> My idea is for driver that provides a filesystem from image files it
> controls. Because it knows these resources it uses access in tandem to
> attain performance.

???
(reads original description in more detail).

So... the filesystem images are identical in both copies, and the
"interesting" bit is that the image is just a file on some filesystem.

So could I implement your idea by:

  dd if=/dev/zero of=/1/bigfile count=lotsandlots
  dd if=/dev/zero of=/2/bigfile count=lotsandlots
  losetup /dev/loop1 /1/bigfile
  losetup /dev/loop2 /2/bigfile
  mdadm -C /dev/md0 --level=raid1 --raid-disks=2 /dev/loop1 /dev/loop2
  mkfs /dev/md0
  mount /dev/md2 /space

??

Why would you bother?  Well, I do it a lot of code testing, but I
would be hard pressed to make a case for that sort of config in
production.

You said:
>  1) the disks need
>    not be the same size or from the same manufacturer; 2) the supporting code
>    would be cross-platform.

md/raid already works happily with different sized drives from
different manufacturers (for raid1, it only uses as much space as the smaller
drive provides, For raid0 it uses it all).
I don't know what you mean by '2'.

So I still cannot see anything particularly new.  What am I missing?

NeilBrown
