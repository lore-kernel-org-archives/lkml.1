Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbYEQUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbYEQUxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYEQUxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:53:13 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62139 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754548AbYEQUxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:53:12 -0400
Date: Sat, 17 May 2008 21:52:27 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Tom Spink <tspink@gmail.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
In-Reply-To: <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Tom Spink wrote:

> static inline unsigned int get_nmi_count(int cpu)
> {
> #ifdef CONFIG_X86_64
>         return cpu_pda(cpu)->__nmi_count;
> #else
>         return nmi_count(cpu);
> #endif
> }
> 
> I know it introduces a lot of these conditionals, but at least there
> is one place to look for the get_nmi_count function, instead of
> searching for all variants of the function.

 Well, I suppose some header should provide a definition like:

#ifdef CONFIG_X86_64
#define cpu_x86_64 1
#else
#define cpu_x86_64 0
#endif

and the you can remove the horrible #ifdef clutter and make the quoted 
function look like:

static inline unsigned int get_nmi_count(int cpu)
{
	return cpu_x86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
}

Much better -- isn't it?

  Maciej
