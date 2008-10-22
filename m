Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYJVPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYJVPDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJVPC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:02:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:27729 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYJVPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cIPJKBCSI6hISNbX3170wp+ODza4GJ8q3Uqtpd3iTYHYTtdz39sbbZLt6kajQ3HA9j
         zyIRKesq+H56yKnLPLgjmXGi4ueYgsvuKZWG/U2RA6fFueR+yhdyRaz/TwTcoWoogSp6
         mYPFRRTZbZc4xG8BF9dOCgFtfe3x8G3IragIM=
Date: Wed, 22 Oct 2008 19:02:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022150251.GE9639@localhost>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <20081022141720.GB9639@localhost> <20081022142312.GC26372@elte.hu> <20081022145909.GA7224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022145909.GA7224@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 22, 2008 at 04:59:09PM +0200]
| 
| > > | > -		apic_write(APIC_ESR, 0);
| > > | > -		apic_read(APIC_ESR);
| > > | > +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| > > | > +			apic_write(APIC_ESR, 0);
| > > | > +			apic_read(APIC_ESR);
| > > | > +		}
| 
| this wouldnt build with certain configs:
| 
| arch/x86/kernel/smpboot.c: In function 'do_boot_cpu':
| arch/x86/kernel/smpboot.c:897: error: 'phys_apicid' undeclared (first use in this function)
| arch/x86/kernel/smpboot.c:897: error: (Each undeclared identifier is reported only once
| arch/x86/kernel/smpboot.c:897: error: for each function it appears in.)
| include/asm/io_32.h: In function 'memcpy_fromio':
| 
| because phys_apicid is not available in the !WAKE_SECONDARY_VIA_INIT 
| case. Changed it to boot_cpu_physical_apicid - that should be good 
| enough.
| 
| 	Ingo
| 

Did you fixed it? (oh... actually I've been compilling the patch
but had this CONFIG turned on and didn't catch this issue)

		- Cyrill -
