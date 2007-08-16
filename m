Return-Path: <linux-kernel-owner+w=401wt.eu-S933736AbXHPQ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbXHPQ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764869AbXHPQ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:26:32 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51197 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764833AbXHPQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:26:31 -0400
Date: Thu, 16 Aug 2007 12:24:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>, giedrius@su.lt
Subject: [PATCH] UML - Add a .note.SuSE section
Message-ID: <20070816162428.GA8128@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is both 2.6.24 and -stable material ]

SuSE seems to require that binaries have a .note.SuSE section.
Without it, UML segfaults if any parameters are passed on the command
line.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/dyn.lds.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/dyn.lds.S	2007-08-15 10:39:39.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/dyn.lds.S	2007-08-15 12:07:10.000000000 -0400
@@ -10,6 +10,7 @@ SECTIONS
   PROVIDE (__executable_start = START);
   . = START + SIZEOF_HEADERS;
   .interp         : { *(.interp) }
+  .note.SuSE	  : { *(.note.SuSE) }
   __binary_start = .;
   . = ALIGN(4096);		/* Init code and data */
   _text = .;
