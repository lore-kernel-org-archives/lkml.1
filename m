Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZDGFTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZDGFTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDGFTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:19:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53945 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZDGFTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:19:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <18906.57833.843101.770634@drongo.ozlabs.ibm.com>
Date: Tue, 7 Apr 2009 15:17:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       monstr@monstr.eu, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Michal Simek <monstr@seznam.cz>
Subject: Re: Move dtc and libfdt sources from arch/powerpc/boot to scripts/dtc
In-Reply-To: <20090331044701.GD25418@yookeroo.seuss>
References: <20090331044701.GD25418@yookeroo.seuss>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Gibson writes:

> The vast bulk of this patch is a literal move, the rest is adjusting
> the various Makefiles to use dtc and libfdt correctly from their new
> locations.

Did you test this with a separate object directory?  I get:

$ make O=../test-64k V=1
[snip]
  gcc -Wp,-MD,scripts/dtc/.dtc-lexer.lex.o.d -Iscripts/dtc -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer  -I/home/paulus/kernel/powerpc/scripts/dtc/libfdt -Iscripts/dtc/libfdt -c -o scripts/dtc/dtc-lexer.lex.o scripts/dtc/dtc-lexer.lex.c
dtc-lexer.l:37:17: error: dtc.h: No such file or directory
dtc-lexer.l:38:20: error: srcpos.h: No such file or directory
In file included from dtc-lexer.l:39:
dtc-parser.y:42: error: expected specifier-qualifier-list before ,F!(Buint8_t,F"(B

followed by lots more errors.

Paul.
