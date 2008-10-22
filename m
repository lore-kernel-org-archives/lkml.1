Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYJVORl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYJVORl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYJVOR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:17:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:19308 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbYJVOR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W+jZB0gmOmMbapAdLN5CJmWeTUOiTo+n2Qj9O/jzjFxNM9CmOaJlu2DqPWXisK9hoi
         Rc4agreY/BI66KahVpMUPmTM+Q3ajjsMzeKTMM3l4/3TvBnsBIVVQIBuStCcOAEMk//G
         MIxfMTP7WogSL8tmVJ16mZXtRt9phoVV6XA4I=
Date: Wed, 22 Oct 2008 18:17:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022141720.GB9639@localhost>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022141354.GA26372@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 22, 2008 at 04:13:54PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > We should touch ESR register if only we have it.
| > The patch fixes the problem mentoined here
| > 
| > 	http://lkml.org/lkml/2008/10/17/147
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > CC: Glauber Costa <glommer@gmail.com>
| 
| > -		apic_write(APIC_ESR, 0);
| > -		apic_read(APIC_ESR);
| > +		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
| > +			apic_write(APIC_ESR, 0);
| > +			apic_read(APIC_ESR);
| > +		}
| 
| i'm wondering - is the server there really that old, that it has no 
| integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some 
| other, weird SMP box?
| 
| 	Ingo
| 

I was quite wondering too -- it's Xeon server.

>From http://lkml.org/lkml/2008/10/20/34
>> Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
>> Tell me if you need more detailed information.

		- Cyrill -
