Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZITSN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZITSN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZITSNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:13:25 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40615 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbZITSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xt9xG3WHIt+L+bP/wcyDAJxxU4+D9pAlKhB5z/qNhBnyX7NN12V0wiLEYsLMgsc5b5
         J1tr3X4OY3t/UcqhW4Jtxrpou9PfmrqdNMJc87AgrzYkeK+5t20XBwI2Szznqp2CyCkA
         TIaO6AvKTOB1cnAqsHOtA71e67L6U6ZqGdNGU=
Date: Sun, 20 Sep 2009 22:13:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sheng Yang <sheng@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in
	GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090920181326.GB32176@lenovo>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com> <20090920180632.GB8498@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920180632.GB8498@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Sep 20, 2009 at 08:06:32PM +0200]
| 
| * Sheng Yang <sheng@linux.intel.com> wrote:
| 
| > Otherwise would cause trouble...
| > 
| > Cc: Dimitri Sivanich <sivanich@sgi.com>
| > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
| > ---
| >  arch/x86/kernel/irq.c |    3 ++-
| >  1 files changed, 2 insertions(+), 1 deletions(-)
| > 
| > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
| > index b0cdde6..78b23d0 100644
| > --- a/arch/x86/kernel/irq.c
| > +++ b/arch/x86/kernel/irq.c
| > @@ -257,7 +257,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
| >  {
| >  	struct pt_regs *old_regs = set_irq_regs(regs);
| >  
| > -	ack_APIC_irq();
| > +	if (!disable_apic)
| > +		ack_APIC_irq();
| 
| Wont in that case the apic->ack method be a NOP?
| 
| 	Ingo
| 

iirc it was Xen related patch. So it's not that simple.

I've pointed out Sheng about disable_apic. I'm not Xen
specialist but Xen team seem to use specific apic setup
so our "dummy" operations are not involved (case they
set disable_apic=1 without "turn off" apic ops in real).
Something like that.

	-- Cyrill
