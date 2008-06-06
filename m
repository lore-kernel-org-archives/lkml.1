Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYFFSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYFFSF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYFFSFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:05:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:14517 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbYFFSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hsI3nKsrPbevjZSx3b5aurGdxdBCmYgUAsMqOI+/nWiDbO7YrsjIW1TD0nsOnWQ8wC
         5cG47qgXdCjc4YazlOGNdKF2AUeF5AG5R0JR3uZeBILgVxMRC7xeQkl2Yf8+yojqneEz
         N+JgwB5yk7hVZs4WZ8jWMs+9S2hKruafNXrF8=
Message-ID: <86802c440806061105o7daab2b7xd5d34f6fa206d733@mail.gmail.com>
Date: Fri, 6 Jun 2008 11:05:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v2
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080606140947.GA29104@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806050309.11197.yhlu.kernel@gmail.com>
	 <200806051714.54932.yhlu.kernel@gmail.com>
	 <86802c440806051754l5c921437o15ab12882f42a25d@mail.gmail.com>
	 <20080606061744.GA6399@uranus.ravnborg.org>
	 <86802c440806052327v14428d4dhf54e13874c1f0a5a@mail.gmail.com>
	 <20080606140947.GA29104@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 7:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > It is my understanding that special support for NUMAQ should die, so
>> > the only remaning usage of CONFIG_NUMAQ is if set to select
>> > GENERICARCH. In other words that you should not use CONFIG_NUMAQ
>> > anywhere in the code but solely rely on GENERICARCH and then do
>> > runtime detection of the other things.
>>
>> in case someone don't want to build that special numaq code in.
>>
>> I think we should make ES7000, Summit depend to GENERICARCH too.
>
> correct. If someone wants more restricted support, pure CONFIG_X86_PC
> should do that fine.
>
> also, even GENERICARCH should have as little Kconfig implications as
> possible. I.e. before your cleanups the subarch code was used to
> implement something very non-PC, and it was done build-time - which is a
> PITA in terms of testing and in terms of general complexity. We want to
> remove those complications and eventually we want to remove the subarch
> code altogether. (without narrowing hw support of course)

current

static struct genapic *apic_probe[] __initdata = {
#ifdef CONFIG_X86_NUMAQ
        &apic_numaq,
#endif
        &apic_summit,
        &apic_bigsmp,
        &apic_es7000,
        &apic_default,  /* must be last */
        NULL,
};

the apic_default is the 86_PC.

so could make GENERICARCH default to yes.

and have

static struct genapic *apic_probe[] __initdata = {
#ifdef CONFIG_X86_NUMAQ
        &apic_numaq,
#endif
#ifdef CONFIG_X86_SUMMIT
        &apic_summit,
#endif
#ifdef CONFIG_X86_BIGSMP
        &apic_bigsmp,
#endif
#ifdef CONFIG_X86_ES7000
        &apic_es7000,
Eendif
        &apic_default,  /* must be last */
        NULL,
};


also may expand probe a little bit...to cover other different.

YH
