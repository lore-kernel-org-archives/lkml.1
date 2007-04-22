Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXDVRpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXDVRpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 13:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXDVRpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 13:45:23 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4041 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXDVRpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 13:45:22 -0400
X-AuthUser: hirofumi@parknet.jp
To: 7eggert@gmx.de
Cc: DervishD <lkml@dervishd.net>, Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
	<8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
	<8cAMl-du-3@gated-at.bofh.it> <8cBS7-1Qa-1@gated-at.bofh.it>
	<8cIqE-3qZ-9@gated-at.bofh.it> <8cITG-40H-5@gated-at.bofh.it>
	<E1Hffkv-0001QP-3C@be1.lrz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 23 Apr 2007 02:44:59 +0900
In-Reply-To: <E1Hffkv-0001QP-3C@be1.lrz> (Bodo Eggert's message of "Sun\, 22 Apr 2007 19\:21\:04 +0200")
Message-ID: <87slasqp5w.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

> # /usr/bin/time sh -c "dd if=/dev/hda2 bs=$((77834925/64)) count=4 | perl -e
> '"'use POSIX;while (sysread STDIN,$x,4) {$n++ if $x eq "\0\0\0\0"} print
> $n*32,"\n"'\'
> 4+0 records in
> 4+0 records out
> 13954720
> 0.76user 0.60system 0:01.95elapsed 69%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (8major+1583minor)pagefaults 0swaps

dd will use readahead, and I'm thinking about usb. Well, anyway,
recalc is default in new patch.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
