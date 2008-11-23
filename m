Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYKWSKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYKWSKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKWSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:10:08 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:24081 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYKWSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:10:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IgnGMcP4CrFi46b6DnN9OvOwqATp2xGVit3VfS5pFQ8ZsSJ29yLUM06HMO9xQteguB
         Rf/KvGHzeW2buJtRdRAUJn8xA8N7bUFwyXg1E9K8r0YFYX4VFCcdhQBIOgimWgWZJUOo
         lAxaV1RDDxynzxE49i8NZVD9GvdyOEtMJDnK0=
Date: Sun, 23 Nov 2008 21:10:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123181005.GG12710@localhost>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123175846.GF12710@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Nov 23, 2008 at 08:58:46PM +0300]
| [Sam Ravnborg - Sun, Nov 23, 2008 at 06:51:25PM +0100]
| | On Sun, Nov 23, 2008 at 07:57:11PM +0300, Cyrill Gorcunov wrote:
| | > It's usefull to catch unbalanced, missed or mixed declarations of ENTRY and
| | > KPROBES. These macros would help a bit (at least I hope so).
| | > 
| | > For example the following code would compile without problems
| | > 
| | >         ENTRY_X86(mcount)
| | >                 retq
| | >         END_X86(mcount)
| | > 
| | > But if you forget and mix the following form
| | > 
| | >         ENTRY_X86(mcount)
| | >                 retq
| | >         END(mcount)
| | > 
| | >         ENTRY_X86(ftrace_caller)
| | > 
| | > The assembler will issue the following message:
| | > Error: ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed
| | > 
| | > Actually the checking is performed at every _X86 macro
| | > so maybe it's good idea to put ENTRY_KPROBE_FINAL_X86
| | > at the end of .S file to be sure you didn't miss anything.
| | 
| | Could we at least try this out in -next before we decide to make 
| | this X86 only?
| | I am aware that binutils can be a bit fragile but -next testing should
| | make a good check on this.
| | 
| | 	Sam
| | 
| 
| I don't have -next tree on my laptop, neither cross-compile tools but
| if someone could test it -- it would be great. But I used gas macros
| here -- i doubt other architectures has the same syntax. At least
| PDP-11 would beat us with ';' symbol :)
| 
| 		- Cyrill -

On the other hand, if this feature show 'good' behaviour on x86 we could
propagate it on other arch's. If we just turn it on by default -- lots of
errors will be.

		- Cyrill -
