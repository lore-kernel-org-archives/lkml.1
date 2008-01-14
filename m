Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYANRhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYANRhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYANRhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:37:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:1396 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYANRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gNDiV0sCxJkLbUq/9W7Khx8VyGut8o0IFc/4362IC1UsS494UTqLxh2CVJ/KuJw7dAdgHb4BXzZi7c3dpAkPOV/kNw6jVCfNDRpAVaLdo8ytaz0BdW7yXumwZiCl7fyCS3kcj+VNyhfAqSYPiguYwpRUnf+bytokiFHCMA7tC98=
Message-ID: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
Date: Mon, 14 Jan 2008 17:37:21 +0000
From: "Colin Fowler" <elethiomel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive benchmark on 8 Core Xeon
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me as I'm not subscribed.

I have (what is to me) a strange and very repeatable slowdown for a
CPU intensive benchmark on my system  on newer kernels.

Hardware : Dell Precision 470.
CPU 2x2.0GHz Quad Core Xeon E5335 CPUs
Memory 4GB ECC RAM.
OS Ubuntu x86_64 7.10 (Gutsy Gibbon)
Compiler : gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)

Benchmark : A ray-trace is performed on 500 times on 17 separate
scenes. Workload is distributed by tiling the framebuffer into N 32x32
pixel tiles. Each CPU grabs one of N tiles out of the queue and
repeats until no jobs are left. Rendering is to a shared framebuffer
(obviously this causes problems with caching). Locking and
synchronization is done using pthreads.

Other details: The system is cleanly booted for each run. No I/O is
performed during the timed portions of the test. The benchmark does
however read a model file from the drive and build a data structure
from it before each timed portion.


On the 2.6.22 series of kernels results are pretty much the same. On
2.6.23 series kernels I see a loss in speed of ~2% across the board.
On 2.6.24-rc7 that loss in speed is perhaps very slightly worse (~3%).
2.6.22 Kernels tested: 22.9(Ubuntu Stock Kernel), 22.14, 22.15
2.6.23 Kernels tested: 23.1, 23.3,  23.13
2.6.24 Kernels tested: 24-rc7

I have my kernel compiled to use the SLAB allocator. All other
tweaking options are set as defaults. My config files are available at
http://vangogh.cs.tcd.ie/fowler/configs  . Perhaps I'm configuring
something wrong for the type of work I do?

regards,
        Colin
