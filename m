Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYE1RQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYE1RQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYE1RQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:16:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30574 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYE1RQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=j56ELYS/h+h1e89LzU52L/DeoVt6YhlgFWK6QaExuhCpKSEDbI+ey2D7QUtZTlfB6nJQY/yAM7dv8+nsw2Z/fLmenVTcxvWFXrtgEmDhFUGJNLm8RGyE2wWcMPPainqoutWmxoUR3iyB5ZukRwryT54t4aqRas2IVOm/2uldKRY=
Date: Wed, 28 May 2008 21:16:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
	of apic_write
Message-ID: <20080528171620.GC6910@cvg>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com> <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl> <20080528160413.GA6910@cvg> <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl> <20080528162527.GB6910@cvg> <Pine.LNX.4.55.0805281755370.29522@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805281755370.29522@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, May 28, 2008 at 06:09:38PM +0100]
| On Wed, 28 May 2008, Cyrill Gorcunov wrote:
| 
| > So I've moved a part of code (32bit) from proc_nmi_enabled() to
| > nmi_watchdog_default() BUT this nmi_watchdog_default() also called
| > from smpboot.c:native_smp_prepare_cpus() and before this patch
| > this call was just an empty call (and eliminated by gcc I think)
| > now it's not empy. But how it leads to hang I can't understand.
| > The only thing is done - nmi_watchdog is set to NMI_LOCAL_APIC
| > or NMI_IO_APIC and my only suspicious is that something happens
| > asynchronously and leads to machine hang. Let me know if I wrote
| > in obscure manner.
| 
|  The problem is the I/O APIC NMI watchdog which does not work correctly on
| the reporter's machine.  Your patch makes the NMI watchdog be enabled by
| default on 32-bit platforms (OTOH, proc_nmi_enabled() is only called by an
| explicit request via sysctl).  Unfortunately many hardware vendors have
| not fully recognised the existence of Linux yet and the NMI watchdog
| frequently triggers breakage in SMM firmware even on modern equipment;  
| actually it was less likely to break in the old days.
| 
|   Maciej
| 

Thanks a lot, Maciej!!! Could you please explain me how did you find
that? 'cause reporter said that with nmi_watchdog=2 it works and with
nmi_watchdog=1 it stalls? Maybe I should better make this function
the same as 64bit version has? I.e. set nmi_watchdog = NMI_NONE by default?

		- Cyrill -
