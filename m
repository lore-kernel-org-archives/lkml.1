Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYHQNMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYHQNMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 09:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYHQNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 09:12:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:20412 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYHQNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 09:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8pDR54yMPkQfZbkJsZNQ6sk/+kyLwdyY2cGaVcF135cJHNbB5/0IwlqriIeK6stwV
         glkTrlnjhbzVZQjfwPeHLC0OL1fTHhqYrufpjSHrYirwEMDcNMVWrpzqsEEiH6Qpr+Mn
         Q1Eeqo0pH+pphSIjk9NmA5TyhWD2xZWZKPVUQ=
Date: Sun, 17 Aug 2008 17:12:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: one more apic merging preliminary series
Message-ID: <20080817131204.GB7418@lenovo>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <20080817124540.GF21434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817124540.GF21434@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Aug 17, 2008 at 02:45:40PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Please review - any comments are welcome!
| > 
| > For now it's like code bloating - but it's just preliminary series to 
| > make apic_*.c code more or less similar. And it's still a bit far from 
| > being ready to be merged down.
| 
| applied to tip/x86/apic - thanks Cyrill.
| 
| Maciej's point about cleaning up the x2apic impact is very much true - 
| i've Cc:-ed Suresh and Venki. Even if we wont truly use x2apic in 32-bit 
| kernels, it's a piece of glue hardware that does not depend on which 
| mode the CPU is in, so support for it should be bitsize agnostic. It 
| will also obviously be good for test coverage, once x2apic capable hw 
| will be more widespread.
| 
| 	Ingo
| 

Thanks Ingo. I found a bit obscure point in APIC 32bit code -
disable_esr variable to be clear. Code reading didn't answer
me the question "for what is needed". 82489DX doesn't have ESR
register indeed I presumed that the variable is needed to set
'absence-flag' of a such register on some platform but it seems
the only code snippet where we use this flag is 32bit lapic_setup_esr.
Moreover others 32bit writers don't check for this feature but
just writting to ESR register...

		- Cyrill -
