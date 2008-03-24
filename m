Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYCXWTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYCXWTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYCXWTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:19:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58313 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYCXWT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:19:29 -0400
Date: Mon, 24 Mar 2008 23:19:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: linux-crypto@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: strange crypto speeds, sort of
Message-ID: <alpine.LNX.1.10.0803242307280.9368@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


How come reading a file from a filesystem on an encrypted block device
is faster than reading the encrypted block device itself?

Linux home 2.6.23.17-rt #1 SMP PREEMPT RT 2007/10/26 14:17:15 
UTC i686 athlon i386 GNU/Linux
cryptsetup 1.0.5

/home # echo 3 >/proc/sys/vm/drop_caches
/home # dd_rescue foo /dev/null
...
Summary for foo -> /dev/null:
dd_rescue: (warning): /dev/null (120704.0k): Invalid argument!
dd_rescue: (info): ipos:    120704.0k, opos:    120704.0k, xferd:    120704.0k
                    errs:      0, errxfer:         0.0k, succxfer:    120704.0k
              +curr.rate:     8728kB/s, avg.rate:    13482kB/s, avg.load:  7.1%

/home # echo 3 >/proc/sys/vm/drop_caches
/home # dd_rescue /dev/mapper/home /dev/null
...
Summary for /dev/mapper/home -> /dev/null:
dd_rescue: (info): ipos:     21504.0k, opos:     21504.0k, xferd:     21504.0k
                    errs:      0, errxfer:         0.0k, succxfer:     21504.0k
              +curr.rate:     4291kB/s, avg.rate:     4291kB/s, avg.load:  5.8%
