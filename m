Return-Path: <linux-kernel-owner+w=401wt.eu-S965944AbXCFRCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944AbXCFRCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965945AbXCFRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:02:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:36574 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965944AbXCFRCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:02:43 -0500
Subject: get_order() broken !
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 18:02:35 +0100
Message-Id: <1173200555.9349.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, maybe I have lots of shit in my eyes.... but it looks like get_order
in asm-generic/page.h is broken.

AFAIK, get_order() should round up (and we have code here or there
assuming such).

However, it seems to assume that ilog2 rounds up, which it doesn't. It
rounds down. At least the generic implementation seems to do so and the
powerpc optimized one too.

So I end up for example with get_order(0x1020) returning ... 0 (which
explains some memory corruption problems I'm having on ppc32 among
others0.

So who is right and who is wrong ? Should we audit all users of these
things ?

Cheers,
Ben.


