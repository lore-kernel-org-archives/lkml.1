Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYEUSrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYEUSrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763118AbYEUSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:47:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760314AbYEUSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tMdY0Nz5lk6vURVqWjx34UZj8tAfeT+FD9GQ+7kOI1+7p7TEQQcqnA27TT7W1lclv744A2xnjxhXfB1SixGKQpxIAPHpbpdGb7csx3XAxMH4sEM62NxkLKc+bEnSbdj+BVp10CVkyycYegNTmiEVbbA/ccV1E+FwLW2XN4XGOMM=
Date: Wed, 21 May 2008 22:47:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merging nmi 32/64 to nmi.c v2
Message-ID: <20080521184711.GC6932@cvg>
References: <20080521163051.GB6932@cvg> <483467E1.6090808@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483467E1.6090808@ct.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hiroshi Shimamoto - Wed, May 21, 2008 at 11:20:17AM -0700]
| Cyrill Gorcunov wrote:
| > This is a second attempt to merge nmi-32/64 to nmi.c
| 
| Hi Cyrill,
| 
| cool work!
| 
| > Summary changes:
| > 
| ...
| > - last_irq_sums and alert_counter was defined as static arrays in 32bit
| >   mode, so they were changed to per_cpu variables
| 
| This was already done, see http://lkml.org/lkml/2008/5/2/525.
| But it doesn't affect the unified file.
| 
| > +#ifdef CONFIG_X86_64
| > +static unsigned ignore_nmis;
| > +
| > +asmlinkage notrace __kprobes void
| > +do_nmi(struct pt_regs *regs, long error_code)
| > +{
| > +	nmi_enter();
| > +	add_pda(__nmi_count,1);
| > +	if (!ignore_nmis)
| > +		default_do_nmi(regs);
| > +	nmi_exit();
| > +}
| > +
| > +void stop_nmi(void)
| > +{
| > +	acpi_nmi_disable();
| > +	ignore_nmis++;
| > +}
| > +
| > +void restart_nmi(void)
| > +{
| > +	ignore_nmis--;
| > +	acpi_nmi_enable();
| > +}
| > +#endif /* CONFIG_X86_64 */
| 
| I'm guessing we can move these functions to traps_64.c.
| I've tried to move these functions from traps_32.c to nmi_32.c,
| but it caused build error on some 32bit configs.
| 
| thanks,
| Hiroshi Shimamoto
| 

Hi Hiroshi,

thanks a lot for reply. I will check if it would be possible
to move them to traps_64.c. Thanks ;)

		- Cyrill -
