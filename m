Return-Path: <linux-kernel-owner+w=401wt.eu-S1161591AbXBOWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161591AbXBOWlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161590AbXBOWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:41:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37360 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161589AbXBOWlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:41:52 -0500
Date: Thu, 15 Feb 2007 14:41:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: sparse chokes on arch/i386/kernel/i8253.c (was: 2.6.20-mm1)
Message-Id: <20070215144142.0c13580a.akpm@linux-foundation.org>
In-Reply-To: <45D483D7.2040609@imap.cc>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D483D7.2040609@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 17:01:27 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Trying to build 2.6.20-mm1 on i386 with C=1, sparse 0.2 chokes
> on arch/i386/kernel/i8253.c:
> 
>   CHECK   arch/i386/kernel/i8253.c
> linux/marker.h: No such file or directory
> include/linux/jiffies.h:18:5: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:20:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:22:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:24:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:26:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:28:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:30:7: warning: undefined preprocessor identifier 'CONFIG_HZ'
> include/linux/jiffies.h:33:3: error: You lose.
> include/linux/jiffies.h:225:5: error: bad constant expression
> include/asm/module.h:64:2: error: unknown processor family
> include/asm/processor.h:82:30: error: undefined identifier 'CONFIG_X86_L1_CACHE_SHIFT'
> include/asm/processor.h:82:30: error: bad constant expression type
> arch/i386/kernel/i8253.c:120:16: error: Expected ; at end of declaration
> arch/i386/kernel/i8253.c:120:16: error: got pit_read
> arch/i386/kernel/i8253.c:128:2: error: Trying to use reserved word 'do' as identifier
> arch/i386/kernel/i8253.c:128:2: error: Expected ; at end of declaration
> arch/i386/kernel/i8253.c:128:2: error: got {
> [loads of similar messages omitted ...]
> arch/i386/kernel/i8253.c:195:2: error: undefined identifier 'clocksource_pit'
> arch/i386/kernel/i8253.c:196:9: error: undefined identifier 'clocksource_register'
> arch/i386/kernel/i8253.c:41:7: error: Expected constant expression in case statement
> arch/i386/kernel/i8253.c:50:7: error: Expected constant expression in case statement

Me too.  It's due to the linux-kernel-markers patches.  Mathieu, can you
take a look please?
