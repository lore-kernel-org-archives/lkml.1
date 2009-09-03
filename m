Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbZICW4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbZICW4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbZICW4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:56:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932426AbZICW4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:56:00 -0400
Date: Thu, 3 Sep 2009 15:55:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
       kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset
 registers
Message-Id: <20090903155539.ecd64bcd.akpm@linux-foundation.org>
In-Reply-To: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
References: <20090831073429.GA26596@liondog.tnic>
	<1251705011-18636-1-git-send-email-petkovbb@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 09:50:09 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> +.macro op_safe_regs op:req

Using

GNU assembler 2.16.1

I get

arch/x86/lib/msr-reg.S: Assembler messages:
arch/x86/lib/msr-reg.S:53: Error: Bad macro parameter list
arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic

this:

diff -puN arch/x86/lib/msr-reg.S~a arch/x86/lib/msr-reg.S
--- a/arch/x86/lib/msr-reg.S~a
+++ a/arch/x86/lib/msr-reg.S
@@ -50,7 +50,7 @@ ENDPROC(native_\op\()_safe_regs)
 
 #else /* X86_32 */
 
-.macro op_safe_regs op:req
+.macro op_safe_regs op
 ENTRY(native_\op\()_safe_regs)
        CFI_STARTPROC
        pushl_cfi %ebx


fixed it.
