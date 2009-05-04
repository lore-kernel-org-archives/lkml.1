Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZEDXZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZEDXZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZEDXZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:25:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:51886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZEDXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:25:00 -0400
Date: Mon, 4 May 2009 16:26:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
 non-privileged processes
Message-ID: <20090504162607.6c771323@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
	<20090504125124.0f469970@infradead.org>
	<m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 15:24:15 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 4 May 2009, Eric W. Biederman wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > On Mon, 4 May 2009 12:00:12 -0700 (PDT)
> > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > >
> > >> 
> > >> 
> > >> On Mon, 4 May 2009, Jake Edge wrote:
> > >> >
> > >> > This is essentially v2 of "[PATCH] proc: avoid leaking eip,
> > >> > esp, or wchan to non-privileged processes", adding some of
> > >> > Eric Biederman's suggestions as well as the start_stack change
> > >> > (only give out that address if the process is ptrace()-able).
> > >> > This has been tested with ps and top without any ill effects
> > >> > being seen.
> > >> 
> > >> Looks sane to me. Anybody objects?
> > >> 
> > >
> > > Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Looks sane here.
> > 
> > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Ok, applied.
> 
> Also, does anybody have any commentary or opinion on the patch by
> Matt Mackall to use stronger random numbers than "get_random_int()".
> I wonder what the performance impact of that is - "get_random_int()"
> is very cheap by design, and many users may consider calling
> "get_random_bytes()" to be overkill and a potential performance issue.
> 
> Quite frankly, the way "get_random_bytes()" works now (it does a
> _full_ sha thing every time), I think it's insane overkill. But I do
> have to admit that our current "get_random_int()" is insane
> _underkill_.
> 
> I'd like to improve the latter without going to quie the extreme that 
> matt's patch did.

doing something simple as hashing in the tsc will already help;
while some people are nervous about the predictability of the tsc,
in practice there's likely enough bits of unpredictability there
to be worth the very low price of 50 cycles or less....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
