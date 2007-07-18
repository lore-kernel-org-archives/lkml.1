Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXGRFDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXGRFDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXGRFDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:03:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:41111 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbXGRFDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:03:10 -0400
Date: Wed, 18 Jul 2007 00:02:46 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: bzolnier@gmail.com
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org
Subject: compile error if CONFIG_BLOCK not enabled related to linux/ide.h
 include
Message-ID: <Pine.LNX.4.64.0707172353050.29097@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

M:      bzolnier@gmail.com
L:      linux-ide@vger.kernel.org

We get the following compile error if CONFIG_BLOCK isn't enabled:

  CC      arch/powerpc/kernel/setup_32.o
In file included from arch/powerpc/kernel/setup_32.c:14:
include/linux/ide.h:558: error: expected specifier-qualifier-list before 'request_queue_t'
include/linux/ide.h:696: warning: 'struct request' declared inside parameter list
include/linux/ide.h:696: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/ide.h:820: warning: 'struct request' declared inside parameter list
include/linux/ide.h:853: error: field 'wrq' has incomplete type
include/linux/ide.h:1205: error: expected ')' before '*' token
make[1]: *** [arch/powerpc/kernel/setup_32.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

What I'm trying to figure out is if include/linux/ide.h should be wrapped
in a #if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE) or if there is
some other desired way to handle this.

This seems to stem from the fact that include/linux/blkdev.h is wrapped in
a CONFIG_BLOCK and thus request_queue_t isn't always defined.

- k


