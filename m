Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZBMLMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZBMLMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBMLMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:12:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbZBMLMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:12:39 -0500
Date: Fri, 13 Feb 2009 12:12:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64}
	builds
Message-ID: <20090213111222.GA15679@elte.hu>
References: <1234372298.3586.23.camel@macbook.infradead.org> <20090211172258.GE13239@elte.hu> <20090212072644.GA10253@elte.hu> <1234427819.3586.142.camel@macbook.infradead.org> <499481F2.3040107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499481F2.3040107@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> David Woodhouse wrote:
>>
>> Ew, that's a nasty thing to be prioritising over day-to-day usability,
>> and the fact that I can't just do 'make bzImage' without it screwing up
>> and asking me to reconfigure.

That argument is flawed because it could be used against just about any
regression that happens in the kernel: if only the new behavior is
deemed more important than the regression that it introduces.

As i said, there's no real problem here, i dont mind the change you are
proposing, but it needs to be done without introducing clearly
nonsensical regressions.

>> Isn't there a CONFIG_RANDCONFIG option? We could make it
>>    bool "64-bit kernel" if !CONFIG_RANDCONFIG
>>
>> Alternatively, we could just the top-level Makefile set ARCH=x86 when
>> it's inferred from the environment, and let people override it to i386
>> or x86_64 if they want to.
>>
>
> I think the fundamental problem here is that "make randconfig" is  
> allowed to retain *any* information from the previous .config; the same  
> is true for "make all*config", "make defconfig", etc.  These by  
> definition should blast the current configuration away.
>
> Now, "make randconfig" should ideally be able to generate either a 32-  
> or a 64-bit configuration (which would have to be done correctly), but  
> if ARCH is set we need to honor it.

Yep, as long as an explicit ARCH override is honored i dont mind some
side-effects on randconfig. (although people do have scripting around
randconfig so we need to make sure it's all sane.)

	Ingo
