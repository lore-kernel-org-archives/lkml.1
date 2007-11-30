Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbXK3TBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbXK3TBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762479AbXK3TBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:01:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:51404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761537AbXK3TBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:01:03 -0500
Date: Fri, 30 Nov 2007 11:01:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more "generic"
In-Reply-To: <20071130184952.GC9928@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301055470.2031@schroedinger.engr.sgi.com>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com>
 <20071130111000.GA32431@elte.hu> <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
 <20071130171419.GA18808@elte.hu> <Pine.LNX.4.64.0711300915460.32253@schroedinger.engr.sgi.com>
 <20071130175825.GA19571@elte.hu> <20071130181206.GA1586@elte.hu>
 <Pine.LNX.4.64.0711301033580.1806@schroedinger.engr.sgi.com>
 <20071130184952.GC9928@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> i have lockdep off. config attached.

The .config does not compile under mm. Could you verify that the first 
patchset applies (this one) and works fine before we get to to the 
patchset that deals with relocating the percpu addresses?

Seems that there are some other funky features on:

CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000

I gotta see how much of that is available under mm and how it interacts 
with the relocation of the percpu area.

christoph@stapp:~/linux-2.6.24-rc3-mm2$ make -j9 all
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      scripts/mod/empty.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/asm/page.h:5,
                 from include/asm/processor_64.h:9,
                 from include/asm/processor.h:4,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/asm/page_64.h:97:2: error: #error "CONFIG_PHYSICAL_START must be a 
multiple of 2MB"
  HOSTLD  scripts/mod/modpost
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1


