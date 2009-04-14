Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZDNRor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZDNRor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZDNRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:44:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:17812 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cgvTIQ4/QJ8Ebu8Xm2GbrtqRf2kwLIiHKXxkILTBFpOfc+5cQ+a3dlNqkeHSEHGJIb
         mxPOCNxZajQ69gtubTaUuvJdG5A2zCdYU1TunhcEw9p5XNjy6lShkLgSQycXD5EGwVB5
         eSLnTLYrRQriszbJpSGlR5eGqpraAjnhZ2ADw=
Date: Tue, 14 Apr 2009 21:44:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 10/14] [VOYAGER] x86: make disabling the apics
	functional instead of a flag
Message-ID: <20090414174427.GA24578@lenovo>
References: <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com> <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com> <20090414170942.GC12888@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414170942.GC12888@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Apr 14, 2009 at 09:09:42PM +0400]
...
| | diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| | index f9e830e..aa96dbe 100644
| | --- a/arch/x86/kernel/apic/apic.c
| | +++ b/arch/x86/kernel/apic/apic.c
| | @@ -1539,6 +1539,9 @@ void __init early_init_lapic_mapping(void)
| |   */
| |  void __init init_apic_mappings(void)
| |  {
| | +	if (disable_apic)
| | +		return;
| | +
| 
| No, we shouldn't do that without additional
| code review (otherwise we will loose mapping for fake apic page).
| And I suspect we get NULL deref on reboot procedure
| if kernel was compiled _with_ SMP support but APIC disabled
| by kernel option. hmm, can't find this reference in LKML.
| I was telling Ingo about my suspicious on smp operations
| when APIC is disabled by option and we're safe _only_ 'cause
| we have fake mapping page reserved. For example call of
| smp_send_stop() in kernel/panic.c if kernel was compiled _with_ SMP
| support and then APIC disabled by kernel option.
| 
| |  	if (x2apic) {
| |  		boot_cpu_physical_apicid = read_apic_id();
| |  		return;
...

Ah, I found that link -- http://lkml.org/lkml/2009/4/12/139
I've promised to take a look, unfortunately out of time now.
Maybe a bit later.

       Cyrill
