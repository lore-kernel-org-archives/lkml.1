Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYLLV2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYLLV2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYLLV15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:27:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:60638 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYLLV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Bn0GhA4OAt2fy/ESAEQixjPkZYOPk7yndhkNtegHpXeq5iUxXawXHfw7IZSzdvWS4M
         5fLcTkfqehdFRZePVaiH0aUYjKGDU5tCG4aXqWtn2DxROUnW7M+Opu1TtqKqXP5hNJG4
         n8sPmfJ/Xpp7pbrFmpErTRoww2fnicl91NTYE=
Date: Sat, 13 Dec 2008 00:27:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212212752.GA31243@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven Rostedt - Fri, Dec 12, 2008 at 04:22:49PM -0500]
| 
| On Fri, 12 Dec 2008, Cyrill Gorcunov wrote:
| 
| > [Steven Rostedt - Fri, Dec 12, 2008 at 03:52:56PM -0500]
| > | 
| > ... 
| > | You can put them in arch/x86/include/asm/ftrace.h That's assembly safe.
| > | 
| > | -- Steve
| > | 
| > 
| > Yep, while you were typing the message I was testing the change :)
| > Do you like it?
| > 
| > 		- Cyrill -
| > 
| > ---
| >  arch/x86/include/asm/ftrace.h |   29 ++++++++++++++++++++-
| >  arch/x86/kernel/entry_64.S    |   57 +++++-------------------------------------
| >  2 files changed, 35 insertions(+), 51 deletions(-)
| > 
| > Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
| > +++ linux-2.6.git/arch/x86/include/asm/ftrace.h
| > @@ -1,6 +1,33 @@
| >  #ifndef _ASM_X86_FTRACE_H
| >  #define _ASM_X86_FTRACE_H
| >  
| > +#ifdef __ASSEMBLY__
| 
| Why add assembly condition? We only want this if CONFIG_FUNCTION_TRACER 
| is enabled, right?  We could combine it with the current #ifndef inside 
| the CONFIG_FUNCTION_TRACER. But I would make do:
| 
| #ifdef __ASSEMBLY__
| <your stuff>
| #else
| < C stuff >
| #endif
| 
| -- Steve
...

OK, will back shortly.

		- Cyrill -
