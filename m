Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZBIR0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZBIR0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZBIRZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:25:56 -0500
Received: from gw.goop.org ([64.81.55.164]:55232 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZBIRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:25:55 -0500
Message-ID: <49906722.3060905@goop.org>
Date: Mon, 09 Feb 2009 09:25:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, pgtable.h: fix 2-level 32-bit build
References: <498CCFB5.3000706@goop.org> <20090209102211.GJ20467@elte.hu> <20090209103322.GL20467@elte.hu> <20090209104438.GA16729@elte.hu> <20090209110009.GA26517@elte.hu>
In-Reply-To: <20090209110009.GA26517@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Please double check the fix below.
>
> Regarding the page.h include - maybe we should introduce asm/page_types.h just for 
> the bare essentials? OTOH ... x86 asm/page.h already seems bare essentials.
>
> Regarding types, each include file should be self-sufficient.
>   

I did some more work on this last night, resulting in the series below.  
It introduces a series of *-defs.h headers which define constants and 
very simple inlines without any complex external dependencies (they 
depend on either other asm/*-defs.h headers, or basic common headers 
like linux/types.h).

The following changes since commit fd95fb02f7ac3c96f2a8db4a8f0a04fdc4db5731:
  Jeremy Fitzhardinge (1):
        Include linux/mmzone to avoid cyclic dependency

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/untangle

Jeremy Fitzhardinge (9):
      Revert "Include linux/mmzone to avoid cyclic dependency"
      Split pgtable.h into pgtable-defs.h and pgtable.h
      Split pgtable_32.h into pgtable_32.h and pgtable_32-defs.h
      Split pgtable_64.h into pgtable_64-defs.h and pgtable_64.h
      Include pgtable_32|64-defs.h in pgtable-defs.h
      create -defs.h counterparts for page*.h
      x86: move 2 and 3 level asm-generic defs into page-defs
      x86: move defs around to allow paravirt.h to just include page-defs.h
      define pud_flags and pud_large properly to allow non-PAE builds

 arch/x86/include/asm/page-defs.h       |  155 ++++++++++++++++++++++
 arch/x86/include/asm/page.h            |  145 +--------------------
 arch/x86/include/asm/page_32-defs.h    |   92 +++++++++++++
 arch/x86/include/asm/page_32.h         |   89 +------------
 arch/x86/include/asm/page_64-defs.h    |  105 +++++++++++++++
 arch/x86/include/asm/page_64.h         |  101 +--------------
 arch/x86/include/asm/paravirt.h        |    2 +-
 arch/x86/include/asm/pgtable-defs.h    |  226 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/pgtable.h         |  223 +------------------------------
 arch/x86/include/asm/pgtable_32-defs.h |   46 +++++++
 arch/x86/include/asm/pgtable_32.h      |   42 +------
 arch/x86/include/asm/pgtable_64-defs.h |   46 +++++++
 arch/x86/include/asm/pgtable_64.h      |   48 +-------
 drivers/char/hvc_xen.c                 |    1 -
 14 files changed, 686 insertions(+), 635 deletions(-)
 create mode 100644 arch/x86/include/asm/page-defs.h
 create mode 100644 arch/x86/include/asm/page_32-defs.h
 create mode 100644 arch/x86/include/asm/page_64-defs.h
 create mode 100644 arch/x86/include/asm/pgtable-defs.h
 create mode 100644 arch/x86/include/asm/pgtable_32-defs.h
 create mode 100644 arch/x86/include/asm/pgtable_64-defs.h

	J


