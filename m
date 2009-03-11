Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZCLCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZCLCax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZCLCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:30:44 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:56746 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZCLCao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:30:44 -0400
Date: Thu, 12 Mar 2009 00:11:56 +0100
From: =?UTF-8?B?RnJhbsOnb2lz?= Cami <francois.cami@free.fr>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <theotso@us.ibm.com>,
       Martin Watson <mjwatsonuk@yahoo.co.uk>
Subject: Re: 2.6.28.7/ext2/e2fsprogs-1.41.3: apparently irreparable
 filesystem damage, filesystem not imageable
Message-ID: <20090312001156.004e775e@free.fr>
In-Reply-To: <87prgnpw1c.fsf@hades.wkstn.nix>
References: <87prgnpw1c.fsf@hades.wkstn.nix>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 21:52:15 +0000
Nix <nix@esperi.org.uk> wrote:

(...)

> OK, time to image it to another ext2 filesystem with enough space (there
> isn't enough unpartitioned space, we have to put it in a file). We imaged
> from an LVM snapshot to ensure that nothing could possibly futz with the fs
> while we imaged it:
> 
> ,----
> | root@beast:/var/log/fsck# dd if=/dev/disks/home-snap of=/mnt/horizon/home.img bs=10240000 & DDPID=$!
> | [1] 2821
> | [...]
> | root@beast:/var/log/fsck# while sleep 30; do kill -USR1 $DDPID; done
> | 1665+0 records in
> | 1664+0 records out
> | 17039360000 bytes (17 GB) copied, 1611.98 s, 10.6 MB/s
> | dd: writing `/mnt/horizon/home.img': File too large
> | 1685+0 records in
> | 1684+0 records out
> | 17247252480 bytes (17 GB) copied, 1630.96 s, 10.6 MB/s
> | [1]+  Exit 1                  dd if=/dev/disks/home-snap of=/mnt/horizon/home.img bs=10240000
> `----
> 
> The only phrase that springs to mind now is 'WTF'? I've never heard of a
> 17Gb -EFBIG limit before. Certainly it's not O_LARGEFILE-related: a
> quick strace shows dd(1) opening both inputs and outputs with
> O_LARGEFILE, as everyone has since the year dot. Some completely weird
> kernel bug?
> 
> What on earth is going on?

AFAIK you are hitting the 16GB file size limit of a 1KB-block formatted
ext{2,3} filesystem on /mnt/horizon/ .

François
