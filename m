Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbXKFJaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbXKFJaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbXKFJ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:29:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbXKFJ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:29:52 -0500
Date: Tue, 6 Nov 2007 01:29:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jimenez <pj@place.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] KJ: Make i8259_64 more _32-like
Message-Id: <20071106012912.8b205ce6.akpm@linux-foundation.org>
In-Reply-To: <20071030152957.DD9FC8B2B@place.org>
References: <20071030064050.C401D8B2B@place.org>
	<alpine.LFD.0.9999.0710300959100.3186@localhost.localdomain>
	<20071030152957.DD9FC8B2B@place.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:29:57 -0500 Paul Jimenez <pj@place.org> wrote:

>  This patch mainly hinges around two includes and their ramifications:
>  
>  #include <i8259.h>	which provides cached_{slave,master}_mask
>  #include <io_ports.h>	which provides PIC_{MASTER,SLAVE}_{IMR,CMD} 
>  
>  Adding these two includes and using those half dozen or so definitions
>  removed 140+ lines of diffs between i8259_32.c and i8259_64.c, thus
>  making it easier for the real substantitive differences between them to
>  show up, and hopefully therefore making it easier to eventually merge
>  the two.  All the warnings that checkpatch.pl throws (missing spaces
>  after commas and >80 character lines) exist intentionally to match
>  i8259_32.c.

x86_64 allnoconfig:

arch/x86/kernel/i8259_64.c:26:22: error: io_ports.h: No such file or directory
arch/x86/kernel/i8259_64.c:120: error: static declaration of 'cached_irq_mask' follows non-static declaration
include/asm/i8259.h:4: error: previous declaration of 'cached_irq_mask' was here
arch/x86/kernel/i8259_64.c: In function 'disable_8259A_irq':
arch/x86/kernel/i8259_64.c:141: error: 'PIC_SLAVE_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:141: error: (Each undeclared identifier is reported only once
arch/x86/kernel/i8259_64.c:141: error: for each function it appears in.)
arch/x86/kernel/i8259_64.c:143: error: 'PIC_MASTER_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'enable_8259A_irq':
arch/x86/kernel/i8259_64.c:155: error: 'PIC_SLAVE_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:157: error: 'PIC_MASTER_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'i8259A_irq_pending':
arch/x86/kernel/i8259_64.c:169: error: 'PIC_MASTER_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:171: error: 'PIC_SLAVE_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'i8259A_irq_real':
arch/x86/kernel/i8259_64.c:198: error: 'PIC_MASTER_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:203: error: 'PIC_SLAVE_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'mask_and_ack_8259A':
arch/x86/kernel/i8259_64.c:242: error: 'PIC_SLAVE_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:244: error: 'PIC_SLAVE_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:245: error: 'PIC_CASCADE_IR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:245: error: 'PIC_MASTER_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:247: error: 'PIC_MASTER_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'i8259A_shutdown':
arch/x86/kernel/i8259_64.c:321: error: 'PIC_MASTER_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:322: error: 'PIC_SLAVE_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c: In function 'init_8259A':
arch/x86/kernel/i8259_64.c:356: error: 'PIC_MASTER_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:357: error: 'PIC_SLAVE_IMR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:362: error: 'PIC_MASTER_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:366: error: 'MASTER_ICW4_DEFAULT' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:366: error: 'PIC_ICW4_AEOI' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:370: error: 'PIC_SLAVE_CMD' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:372: error: 'PIC_CASCADE_IR' undeclared (first use in this function)
arch/x86/kernel/i8259_64.c:373: error: 'SLAVE_ICW4_DEFAULT' undeclared (first use in this function)
