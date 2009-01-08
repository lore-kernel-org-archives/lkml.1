Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZAHMJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZAHMJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZAHMJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:09:00 -0500
Received: from hydra.ck.polsl.pl ([157.158.1.11]:16738 "EHLO hydra.ck.polsl.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZAHMI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:08:59 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 07:08:59 EST
Date: Thu, 8 Jan 2009 13:03:38 +0100
From: Adam Osuchowski <adwol@zonk.pl>
To: linux-kernel@vger.kernel.org
Subject: Is 386 processor still supported?
Message-ID: <20090108120338.6b8b4567@zonk.pl>
Reply-To: Adam Osuchowski <adwol@zonk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, I found such piece of code in kernel 2.6.28 compiled for 386
processor:

# grep M386 .config
CONFIG_M386=y
# objdump -d vmlinux | grep -A11 '<_spin_lock>:'
c0321827 <_spin_lock>:
c0321827:	89 e2                	mov    %esp,%edx
c0321829:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c032182f:	ff 42 14             	incl   0x14(%edx)
c0321832:	ba 00 01 00 00       	mov    $0x100,%edx
c0321837:	f0 66 0f c1 10       	lock xadd %dx,(%eax)
c032183c:	38 f2                	cmp    %dh,%dl
c032183e:	74 06                	je     c0321846 <_spin_lock+0x1f>
c0321840:	f3 90                	pause  
c0321842:	8a 10                	mov    (%eax),%dl
c0321844:	eb f6                	jmp    c032183c <_spin_lock+0x15>
c0321846:	c3                   	ret    

But there is no xadd instruction on 386 processors. It is available on
486+ only. I have no chance to run this kernel on real 386 box, so I can't
check it in practice, but I think it will not run.

It is not compiler problem because it is explicitly written in assembly
in __raw_spin_lock() function (include/asm-x86/spinlock.h) and there is
no alternative code depending on CONFIG_M386.

Regards.
