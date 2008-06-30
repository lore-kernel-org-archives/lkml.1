Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYF3H6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYF3H6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbYF3H6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:58:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56192 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605AbYF3H63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:58:29 -0400
Message-Id: <1214812708.18086.1261039037@webmail.messagingengine.com>
X-Sasl-Enc: 5lqLN35ggziuT7ybVQEEqjRhQ3g7R7rMD7bbmL8NLIfO 1214812708
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Paul Jackson" <pj@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       yhlu.kernel@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, "Andi Kleen" <andi@firstfloor.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
 <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
 <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
 <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241
 <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in
 some kernel info printks
In-Reply-To: <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
Date: Mon, 30 Jun 2008 09:58:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 08:19:13 -0700 (PDT), "Linus Torvalds"
<torvalds@linux-foundation.org> said:
> On Wed, 25 Jun 2008, Johannes Berg wrote:
> > 
> > In networking, we've gone through various incarnations of print_mac()
> > which is similar to the sym() macro Paul proposed, and it turned out to
> > be undesirable because of the way it interacts with static inlines that
> > only optionally contain code at all, the print_mac() function call is
> > still emitted by the compiler. People experimented with marking it
> > __pure but that had other problems.
> 
> You don't even have to go that esoteric.
> 
> Just printing things like "sector_t" or "u64" is painful, because the 
> exact type depends on config options and/or architecture.
> 
> > It would be nice to be able to say
> > 
> > u8 *eaddr;
> > 
> > printk(... %M ..., eaddr);
> 
> For special things, I do think we should extend the format more, and 
> forget about single-character names. It would be lovely to do them as
> %[mac], %[u64], %[symbol] or similar. Because once you don't rely on gcc 
> checking the string, you can do it.

That would confuse the gcc format string checking... A solution that
just crossed my mind is leaving the format string as is (i.e., "%p"),
but prepending it with a special linux-specific string which does not
confuse gcc. Like: "&mac%p"... for simplicity & can be considered always
special in printk, and && can stand for a literal &. (or pick any
other character that is not used frequently in format strings and is
not %, of course.)

> The problem is that right now we absolutely _do_ rely on gcc checking the 
> string, and as such we're forced to use standard patterns, and standard 
> patterns _only_. And that means that %M isn't an option, but also that if 
> we want symbolic names we'd have to use %p, and not some extension.

"&%p" could then be used for a symbol-lookup.

It doesn't help u64, though, but isn't it about time to unify u64 to
"unsigned long long" everywhere, anyhow? Is there any argument against
that except that a big sweep is necessary to clean up new warnings due
to printk format strings?

Greetings,
    Alexander

> But once you drop the 'standard patterns' requirement, I do think you 
> should drop it _entirely_, and not just extend it with some pissant 
> single-character unreadable mess.
> 
> 				Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

