Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXBWLl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXBWLl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932222AbXBWLlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:41:55 -0500
Received: from lucidpixels.com ([75.144.35.66]:45016 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbXBWLly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:41:54 -0500
Date: Fri, 23 Feb 2007 06:41:51 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: linux-raid@vger.kernel.org
Subject: 2.6.20: stripe_cache_size goes boom with 32mb
Message-ID: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Each of these are averaged over three runs with 6 SATA disks in a SW RAID 
5 configuration:

(dd if=/dev/zero of=file_1 bs=1M count=2000)

128k_stripe: 69.2MB/s
256k_stripe: 105.3MB/s
512k_stripe: 142.0MB/s
1024k_stripe: 144.6MB/s
2048k_stripe: 208.3MB/s
4096k_stripe: 223.6MB/s
8192k_stripe: 226.0MB/s
16384k_stripe: 215.0MB/s

When I tried a 32768k stripe, this happened:
p34:~# echo 32768 > /sys/block/md4/md/stripe_cache_size
Connection to p34 closed

I was able to Alt-SysRQ+b but I could not access the console/X/etc, it 
appeared to be frozen.

FYI.

Justin.

