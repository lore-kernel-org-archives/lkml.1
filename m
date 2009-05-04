Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZEDWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZEDWeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZEDWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:34:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbZEDWef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:34:35 -0400
Date: Mon, 4 May 2009 15:24:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <m1vdogbows.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 May 2009, Eric W. Biederman wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Mon, 4 May 2009 12:00:12 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >> 
> >> 
> >> On Mon, 4 May 2009, Jake Edge wrote:
> >> >
> >> > This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
> >> > wchan to non-privileged processes", adding some of Eric Biederman's
> >> > suggestions as well as the start_stack change (only give out that
> >> > address if the process is ptrace()-able).  This has been tested
> >> > with ps and top without any ill effects being seen.
> >> 
> >> Looks sane to me. Anybody objects?
> >> 
> >
> > Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Looks sane here.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Ok, applied.

Also, does anybody have any commentary or opinion on the patch by Matt 
Mackall to use stronger random numbers than "get_random_int()". I wonder 
what the performance impact of that is - "get_random_int()" is very cheap 
by design, and many users may consider calling "get_random_bytes()" to be 
overkill and a potential performance issue.

Quite frankly, the way "get_random_bytes()" works now (it does a _full_ 
sha thing every time), I think it's insane overkill. But I do have to 
admit that our current "get_random_int()" is insane _underkill_.

I'd like to improve the latter without going to quie the extreme that 
matt's patch did.

		Linus
