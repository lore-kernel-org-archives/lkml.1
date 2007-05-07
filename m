Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbXEGRrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbXEGRrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXEGRq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:46:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:26970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXEGRq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="84645318"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch] removes MAX_ARG_PAGES
Date: Mon, 7 May 2007 10:46:49 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01719390@scsmsx411.amr.corp.intel.com>
In-Reply-To: <65dd6fd50705060151m78bb9b4fpcb941b16a8c4709e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] removes MAX_ARG_PAGES
Thread-Index: AcePu9D1QO37NDIaSWKCmmL7DuE5bgBEueqA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ollie Wild" <aaw@google.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       <linux-kernel@vger.kernel.org>, <parisc-linux@lists.parisc-linux.org>,
       <linux-mm@kvack.org>, <linux-arch@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 07 May 2007 17:46:50.0898 (UTC) FILETIME=[B1346720:01C790CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We've tested the following architectures: i386, x86_64, um/i386,
> parisc, and frv.  These are representative of the various scenarios
> which this patch addresses, but other architecture teams should try it
> out to make sure there aren't any unexpected gotchas.

Doesn't build on ia64: complaints from arch/ia64/ia32/binfmt_elf.c
(which #includes ../../../fs/binfmt_elf.c) ...

arch/ia64/ia32/binfmt_elf32.c: In function `ia32_setup_arg_pages':
arch/ia64/ia32/binfmt_elf32.c:206: error: `MAX_ARG_PAGES' undeclared (first use in this function)
arch/ia64/ia32/binfmt_elf32.c:206: error: (Each undeclared identifier is reported only once
arch/ia64/ia32/binfmt_elf32.c:206: error: for each function it appears in.)
arch/ia64/ia32/binfmt_elf32.c:240: error: structure has no member named `page'
arch/ia64/ia32/binfmt_elf32.c:242: error: structure has no member named `page'
arch/ia64/ia32/binfmt_elf32.c:243: warning: implicit declaration of function `install_arg_page'
make[1]: *** [arch/ia64/ia32/binfmt_elf32.o] Error 1

Turning off CONFIG_IA32-SUPPORT, the kernel built, but oops'd during boot.
My serial connection to my test machine is currently broken, so I didn't
get a capture of the stack trace, sorry.

-Tony
