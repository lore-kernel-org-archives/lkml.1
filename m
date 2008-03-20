Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYCTCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYCTCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYCTCIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:08:06 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:18843 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbYCTCIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:08:05 -0400
Date: Thu, 20 Mar 2008 02:07:59 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [mmotm build error] Re: [PATCH,RESEND] Basic braille screen reader support
Message-ID: <20080320020758.GA4545@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
	torvalds@osdl.org, linux-kernel@vger.kernel.org
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080319115726.a4ca9883.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080319115726.a4ca9883.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap, le Wed 19 Mar 2008 11:57:26 -0700, a écrit :
> when O=dir is used in make:
> 
>   CC      drivers/accessibility/braille/braille_console.o
> Assembler messages:
> Fatal error: can't create drivers/accessibility/braille/braille_console.o: No such file or directory
>   CC      crypto/aes_generic.o
> make[3]: *** [drivers/accessibility/braille/braille_console.o] Error 2
> make[2]: *** [drivers/accessibility] Error 2
> make[1]: *** [drivers] Error 2

Oh, right, the patch below should fix it



Properly recurse Makefiles into accessibility and accessibility/braille/

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux-2.6.24.1-perso/drivers/accessibility/Makefile.orig	2008-03-20 01:51:09.000000000 +0000
+++ linux-2.6.24.1-perso/drivers/accessibility/Makefile	2008-03-20 01:52:30.000000000 +0000
@@ -1 +1 @@
-obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille/braille_console.o
+obj-y				+= braille/
--- /dev/null	2008-03-20 02:39:28.130012041 +0000
+++ linux-2.6.24.1-perso/drivers/accessibility/braille/Makefile	2008-03-20 01:52:44.000000000 +0000
@@ -0,0 +1 @@
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille_console.o
