Return-Path: <linux-kernel-owner+w=401wt.eu-S1761875AbXLPXjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbXLPXjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXLPXit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:38:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:10390 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbXLPXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DV7TvVmVGRMYu1KOf6fEfLJ8TzUNP76Cy2UTRv9DmCXLa5QH+tHaBmkIfPIDf4RC+0EUfAaEyPdpfUVRn/wcRAwG0rYJV0E6/24Gdylz8Phkn/HsCSKIbsUy1UyprLGK5fm2mabtLucY5BpZWpm/4GO4z8vV37V8iWD66O47Yf8=
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4765AB32.9040608@zytor.com>
References: <1197806669.3749.44.camel@brick> <20071216153158.GA891@elte.hu>
	 <4765AB32.9040608@zytor.com>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 15:38:51 -0800
Message-Id: <1197848331.3749.86.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-16 at 14:48 -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> >> No differences except for the defintion of local_add_return on X86_64. 
> >> The X86_32 version is just fine as it is protected with ifdef 
> >> CONFIG_M386 so use it directly.
> > 
> > thanks, i've applied your 4 patches to x86.git.
> > 
> > btw., now that we have a single unified file, it might make sense to fix 
> > these checkpatch complaints:
> > 
> >   total: 10 errors, 1 warnings, 257 lines checked
> > 
> > in case you are interested ;-)
> > 
> 
> Please pull them pending revision, they're broken (macros don't expand 
> inside strings...)
> 

Do you have a stylistic preference between these two options:

Option 1) Rely on CPP string constant concatenation

// possibly include trailing space here to avoid remembering
// leading space on the register names
# define _ASM_INC "incl" 

static inline void local_inc(local_t *l)
{
	__asm__ __volatile__(
		_ASM_INC " %0"
		:"+m" (l->a.counter));
}

Option 2) Macro Expansion

# define _ASM_INC(r) \"incl\ ##r\"

static inline void local_inc(local_t *l)
{
	__asm__ __volatile__(
		_ASM_INC(%0);
		:"+m" (l->a.counter));
}

Or some other suggestion.

Harvey



