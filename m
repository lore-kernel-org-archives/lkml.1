Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYKWSLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYKWSLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYKWSL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:11:26 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34567 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYKWSL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:11:26 -0500
Date: Sun, 23 Nov 2008 19:12:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers to catch unbalanced declaration
Message-ID: <20081123181248.GA338@uranus.ravnborg.org>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123175846.GF12710@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 08:58:46PM +0300, Cyrill Gorcunov wrote:
> [Sam Ravnborg - Sun, Nov 23, 2008 at 06:51:25PM +0100]
> | On Sun, Nov 23, 2008 at 07:57:11PM +0300, Cyrill Gorcunov wrote:
> | > It's usefull to catch unbalanced, missed or mixed declarations of ENTRY and
> | > KPROBES. These macros would help a bit (at least I hope so).
> | > 
> | > For example the following code would compile without problems
> | > 
> | >         ENTRY_X86(mcount)
> | >                 retq
> | >         END_X86(mcount)
> | > 
> | > But if you forget and mix the following form
> | > 
> | >         ENTRY_X86(mcount)
> | >                 retq
> | >         END(mcount)
> | > 
> | >         ENTRY_X86(ftrace_caller)
> | > 
> | > The assembler will issue the following message:
> | > Error: ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed
> | > 
> | > Actually the checking is performed at every _X86 macro
> | > so maybe it's good idea to put ENTRY_KPROBE_FINAL_X86
> | > at the end of .S file to be sure you didn't miss anything.
> | 
> | Could we at least try this out in -next before we decide to make 
> | this X86 only?
> | I am aware that binutils can be a bit fragile but -next testing should
> | make a good check on this.
> | 
> | 	Sam
> | 
> 
> I don't have -next tree on my laptop, neither cross-compile tools but
> if someone could test it -- it would be great. But I used gas macros
> here -- i doubt other architectures has the same syntax. At least
> PDP-11 would beat us with ';' symbol :)

If we include this in any of the 100+ trees that Stephen sucks
into -next we will get it tried out.

Ingo has so and so does others so getting it into -next
is rather easy. Then the automated builds will tell of if
it fails on any of the toolchains used there.

	Sam
