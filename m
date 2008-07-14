Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYGSKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYGSKWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYGSKV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:21:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:51415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYGSKV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:21:57 -0400
Message-ID: <487B3160.8070404@kernel.org>
Date: Mon, 14 Jul 2008 19:58:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Rufus & Azrael <rufus-azrael@numericable.fr>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] block: update add_partition() error handling
References: <487B1748.8010107@numericable.fr>
In-Reply-To: <487B1748.8010107@numericable.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rufus & Azrael wrote:
> Hello TJ,
> 
> 
> I try your patch but it fails on apply (see check.c.X in attachment) and
> when compiling the kernel this build error occurs :l
> 
> fs/partitions/check.c:347: erreur: conflicting types for ‘add_partition’
> include/linux/genhd.h:533: erreur: previous declaration of
> ‘add_partition’ was here
> fs/partitions/check.c: In function ‘add_partition’:
> fs/partitions/check.c:406: attention : ‘return’ with a value, in
> function returning void
> fs/partitions/check.c:412: attention : ‘return’ with a value, in
> function returning void
> fs/partitions/check.c: In function ‘rescan_partitions’:
> fs/partitions/check.c:512: erreur: valeur void n'a pas été ignorée comme
> elle aurait dû l'être
> make[2]: *** [fs/partitions/check.o] Erreur 1
> make[1]: *** [fs/partitions] Erreur 2
> make: *** [fs] Erreur 2

Hmmm... are you sure?

> git checkout -f masterAlready on branch "master"
> cat .git/refs/heads/master
bce7f793daec3e65ec5c5705d2457b81fe7b5725
> patch -p1 < ../work/patches/update-add_partition-error
patching file block/ioctl.c
patching file fs/partitions/check.c
Hunk #1 succeeded at 344 (offset 2 lines).
Hunk #2 succeeded at 383 (offset 2 lines).
Hunk #3 succeeded at 505 (offset 2 lines).
patching file include/linux/genhd.h
> make block/genhd.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      block/genhd.o
block/genhd.c: In function ‘add_disk’:
block/genhd.c:195: warning: ignoring return value of
‘sysfs_create_link’, declared with attribute warn_unused_result

The offset message is due to skipping earlier patches but it should just
work.

Thanks.

-- 
tejun
