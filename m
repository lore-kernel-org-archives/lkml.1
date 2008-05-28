Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYE1RKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYE1RKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYE1RKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:10:34 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63358 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751366AbYE1RKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:10:33 -0400
Date: Wed, 28 May 2008 18:09:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
 of apic_write
In-Reply-To: <20080528162527.GB6910@cvg>
Message-ID: <Pine.LNX.4.55.0805281755370.29522@cliff.in.clinika.pl>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com>
 <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl> <20080528160413.GA6910@cvg>
 <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl> <20080528162527.GB6910@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Cyrill Gorcunov wrote:

> So I've moved a part of code (32bit) from proc_nmi_enabled() to
> nmi_watchdog_default() BUT this nmi_watchdog_default() also called
> from smpboot.c:native_smp_prepare_cpus() and before this patch
> this call was just an empty call (and eliminated by gcc I think)
> now it's not empy. But how it leads to hang I can't understand.
> The only thing is done - nmi_watchdog is set to NMI_LOCAL_APIC
> or NMI_IO_APIC and my only suspicious is that something happens
> asynchronously and leads to machine hang. Let me know if I wrote
> in obscure manner.

 The problem is the I/O APIC NMI watchdog which does not work correctly on
the reporter's machine.  Your patch makes the NMI watchdog be enabled by
default on 32-bit platforms (OTOH, proc_nmi_enabled() is only called by an
explicit request via sysctl).  Unfortunately many hardware vendors have
not fully recognised the existence of Linux yet and the NMI watchdog
frequently triggers breakage in SMM firmware even on modern equipment;  
actually it was less likely to break in the old days.

  Maciej
