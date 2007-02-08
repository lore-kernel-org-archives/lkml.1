Return-Path: <linux-kernel-owner+w=401wt.eu-S1422897AbXBHLfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422897AbXBHLfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422900AbXBHLfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:35:53 -0500
Received: from ozlabs.org ([203.10.76.45]:57266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422897AbXBHLfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:35:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17867.1342.763881.188430@cargo.ozlabs.ibm.com>
Date: Thu, 8 Feb 2007 22:10:54 +1100
From: Paul Mackerras <paulus@samba.org>
To: Oleg Verych <olecom@flower.upol.cz>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Kbuild change breaks the ppc64 build
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7 breaks the build on
64-bit powerpc because we no longer get the -m64 flag passed to gcc.
There is code in arch/powerpc/Makefile which adds (or used to add)
-m64 to AS, LD and CC if we are running on a 64-bit machine (which I
am) and have a biarch toolchain (which I do).  Without -m64, the
toolchain assumes 32-bit and all sorts of things break spectacularly.

I haven't yet tracked down exactly why this commit has this effect,
since I find it takes considerable time and effort to understand
Kbuild.

Paul.
