Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZELRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZELRNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZELRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZELRNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:08 -0400
Message-ID: <4A09ADE5.3010102@kernel.org>
Date: Tue, 12 May 2009 10:12:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu> <20090512170246.GB12820@lenovo>
In-Reply-To: <20090512170246.GB12820@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Ingo Molnar - Tue, May 12, 2009 at 06:46:17PM +0200]
> | 
> | got this on a testbox:
> | 
> | [    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()
> | 
> | 	Ingo
> |
> 
> It's expected (unfortunately). If we have SMP compiled kernel
> we still rely on apic_read heavily. Since for fake'ed apic
> we just return 0 for any reading I suspect we could just drop
> WARN_ON_ONCE for native_apic_read_dummy. Yinghai?
> 
> (well, actually we should clean up callees but it would require
>  some effort)

32bit seems doesn't have this warning.

and on 64bit, we always assumed have local APIC there. so could be that noapic is not cleanly enforced

YH
