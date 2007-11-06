Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXKFQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXKFQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXKFQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:04:06 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53415 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbXKFQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:04:05 -0500
Date: Tue, 6 Nov 2007 11:02:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: UML defconfig building failed again
Message-ID: <20071106160250.GB6637@c2.user-mode-linux.org>
References: <20071106114602.GB7652@hacking> <20071106141143.GI8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106141143.GI8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 02:11:43PM +0000, Al Viro wrote:
> Sigh...  Kbuild breakage this time...  See if %s/\<[AC]FLAGS\>/KBUILD_&/g
> in arch/um/Makefile-i386 helps.

Yup, this fixes it:


     [AC]FLAGS -> KBUILD_[AC]FLAGS conversion in Makefile-i386.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile-i386 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index b01dfb0..6729011 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -22,8 +22,8 @@ export LDFLAGS HOSTCFLAGS HOSTLDFLAGS UML_OBJCOPYFLAGS
 endif
 endif
 
-CFLAGS			+= -DCONFIG_X86_32
-AFLAGS			+= -DCONFIG_X86_32
+KBUILD_CFLAGS		+= -DCONFIG_X86_32
+KBUILD_AFLAGS		+= -DCONFIG_X86_32
 CONFIG_X86_32		:= y
 export CONFIG_X86_32

