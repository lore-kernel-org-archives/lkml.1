Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYERHkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYERHkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 03:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYERHjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 03:39:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYERHjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 03:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QjjjP41E6U3wvQDNNDHuoZn1D0WXQWxHwgMTrMeygTO4VJnW6qGB7fgg6Kay+hVp3AmWTU+nxGKU8pH8MCSdLM0vseJWDePIQ2VcSR4TLB/1IiARJoZ8zORRpJR9PH3fun42vwAP+NZ9BTZx95dIzRJwxglAy1vZSFsRI4GOjJs=
Date: Sun, 18 May 2008 11:38:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Tom Spink <tspink@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
Message-ID: <20080518073804.GB6948@cvg>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <alpine.LFD.1.10.0805172331030.18798@apollo.tec.linutronix.de> <482FD9F2.8080204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482FD9F2.8080204@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeremy Fitzhardinge - Sun, May 18, 2008 at 08:25:38AM +0100]
> Thomas Gleixner wrote:
>> Definitely, but we should do it at the Kconfig level which allows us
>> to have integer defines as well, so we end up with something like:
>>
>> static inline unsigned int get_nmi_count(int cpu)
>> {
>>       return CONFIG_X86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
>> }
>>   
>
> Unfortunately that doesn't work because when CONFIG_X86_64 isn't defined it 
> doesn't expand to 0.  It would be nice if CONFIG_* expanded to 0/1, but 
> we'd need to change all the #ifdef CONFIG_* to #if CONFIG_*...
>
>    J
>

I think I would prefer Maciej's advice then but with capital
letters (to easy distinguish them and point an attention) like

#ifdef CONFG_X86_64
#define CPU_64 1
#else
#define CPU_64 0
#endif

		- Cyrill -
