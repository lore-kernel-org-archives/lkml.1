Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXH3OXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXH3OXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXH3OXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:23:01 -0400
Received: from lisa.in-ulm.de ([217.10.8.8]:56079 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756461AbXH3OXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:23:00 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 10:23:00 EDT
Date: Thu, 30 Aug 2007 16:15:28 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: New x886-Setup code breaks HVM-XEN boot
Message-ID: <20070830141528.GA307@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to boot a current 2.6 kernel as a guest under XEN in HVM mode.
With linux-2.6.22.(5) as the guest this works fine but current git kernels
fail very early in the boot process.

The XEN host is a debian kernel with XEN enabled (2.6.18-4-xen-686).
The XEN guest is a vanilla kernel from kernel org booting with LILO
22.6.1 in HVM mode.

I bisected the problem and the bisection points at this commit:
| # bad: [4fd06960f120e02e9abc802a09f9511c400042a5] Use the new x86 setup code for i386
| git-bisect bad 4fd06960f120e02e9abc802a09f9511c400042a5

The boot of a current git snapshot fails as follows:
bash$ sudo xm console guest
LILO 22.6.1 boot: lkcur
Loading lkcur.........................
BIOS data check bypassed
bash$

Note the the xm console command terminates on its own, i.e. the guest
machine seems to halt and not hang somewhere.

I could verify that the real mode code up to the assembly code in
pmjump.S is in fact executed. The problem appears to occur while
enabling protected mode. I tried to put endless loops into the 32-bit
setup code but these were apparently not reached. As far as I understand
this, the protected mode jump in pmjump.S seems to jump into nowhere.

I am willing to do tests with the XEN guest and send any additional
information that might be helpful. However, I cannot change the XEN host
at this time.

Any suggestions? 

     regards  Christian
