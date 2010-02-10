Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0BJXk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:40:26 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60521 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab0BJXkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=UFh0+JN3kMmzraUhGpvRRPHrUGA0jjbp5zKZPAccncRgWZjKVK+Mxy5WqJwdt8vhxV
         ViT04ME/KcGoIFWArz3HbbESP9WNOvKL5O923Gd7flG3HxObIGaDYqMp2AFldFehdrok
         MyZS3GIHpNiMgZauIRICLdFniLEFJRPIgMgow=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: slow resume from suspend to disk
Date: Thu, 11 Feb 2010 01:40:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201002110140.16122.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any way to speed up the resume from suspend to disk? Currently, on my 
laptop it suspends in ~15s (wrote about 360MB) but resumes in ~120s and after 
that I'm still left with ~361MB in swap:

             total       used       free     shared    buffers     cached
Mem:       3333472    1139332    2194140          0      12808     473084
-/+ buffers/cache:     653440    2680032
Swap:      2104472     369428    1735044

Right now I'm better off with a cold boot.

Although I did not study the kernel code to see how things really work, I 
suspect on resume only necessary kernel data is loaded from swap and the 
userland tasks are left with the page fault mechanism to bring back their own 
data, which leads to an I/O storm on the swap device. Maybe changing the I/O 
scheduler from CFQ would help? or better yet, is there any way to tell the 
kernel to bring back all the pages from swap in one quick move? That would be 
something I want to put in my resume scripts.

$ uname -a
Linux mdontu-dell 2.6.32-gentoo-r3 #1 SMP PREEMPT Mon Feb 1 02:36:01 EET 2010 
x86_64 Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel GNU/Linux

I've installed Windows XP just for a test, started a few apps (like visual 
studio, mplayer, etc.) and then suspended/hibernated (~15s). It took roughly 
15s to come back.

Thanks,

PS: I'm editing this e-mail as I do tests and I just noticed that my /sbin 
directory is empty. rmmod is there and I needed it to reload the b43 driver 
which generally does not feel well after a suspend/resume. A reboot fixed it. 
Weird ...

-- 
Mihai Donțu
