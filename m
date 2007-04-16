Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXDPRqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXDPRqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXDPRqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:46:09 -0400
Received: from gherkin.frus.com ([192.158.254.49]:34048 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXDPRqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:46:08 -0400
Subject: [BUG] aic7xxx/aicasm build failure w/gcc-3.4.6
To: linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2007 12:46:05 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070416174605.98260DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This showed up during a 2.6.21-rc7 build after I upgraded gcc from 3.3
to 3.4 on a Slackware system:

make -C drivers/scsi/aic7xxx/aicasm
(...)
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_gram.y:1948: error: conflicting types for 'yyerror'
aicasm_gram.tab.c:3004: error: previous implicit declaration of 'yyerror' was here
aicasm_macro_gram.y:162: error: conflicting types for 'mmerror'
aicasm_macro_gram.tab.c:1196: error: previous implicit declaration of 'mmerror' was here

As a workaround, deleting the "void" declarations for yyerror() and
mmerror() in the respective ".y" files fixes the problem.

Here's the "gcc -v" output:

Reading specs from /usr/lib/gcc/i486-slackware-linux/3.4.6/specs
Configured with: ../gcc-3.4.6/configure --prefix=/usr --enable-shared --enable-threads=posix --enable-__cxa_atexit --disable-checking --with-gnu-ld --verbose --target=i486-slackware-linux --host=i486-slackware-linux
Thread model: posix
gcc version 3.4.6

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
