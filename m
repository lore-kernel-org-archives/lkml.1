Return-Path: <linux-kernel-owner+w=401wt.eu-S934856AbZLQBVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbZLQBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763696AbZLQBU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:57 -0500
Received: from kroah.org ([198.145.64.141]:48112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763681AbZLQBUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:06 2009
Message-Id: <20091217011606.867357237@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [68/90] sparc: Set UTS_MACHINE correctly.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 7f5620a5fcd658f219e85831d3691908f1eccbde ]

"ARCH" can be just about anything, so we shouldn't end up
with UTS_MACHINE of "sparc" in a 64-bit kernel build just
because someone set the personality using 'sparc32' or
similar.  CONFIG_SPARC64 drives the compilation and
therefore provides the definitive value, not "ARCH".

This mirrors commit 8c6531f7a99f29ba8817ffb12cc9ecf190049bd6
(x86: correctly set UTS_MACHINE for "make ARCH=x86")

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -27,6 +27,7 @@ AS             := $(AS) -32
 LDFLAGS        := -m elf32_sparc
 CHECKFLAGS     += -D__sparc__
 export BITS    := 32
+UTS_MACHINE    := sparc
 
 #KBUILD_CFLAGS += -g -pipe -fcall-used-g5 -fcall-used-g7
 KBUILD_CFLAGS += -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
@@ -50,6 +51,7 @@ CHECKFLAGS      += -D__sparc__ -D__sparc
 
 LDFLAGS              := -m elf64_sparc
 export BITS          := 64
+UTS_MACHINE          := sparc64
 
 KBUILD_CFLAGS += -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow   \
                  -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare \


