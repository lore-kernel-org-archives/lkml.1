Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXL3UHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXL3UHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXL3UH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:07:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbXL3UH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:07:26 -0500
Message-ID: <4777F9DD.808@redhat.com>
Date: Sun, 30 Dec 2007 15:04:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes remove fix_riprel #ifdef
References: <1198466917.6323.15.camel@brick> <47773CAD.7050907@redhat.com> <20071230132337.GF16946@elte.hu> <4777B0AA.9050503@redhat.com> <20071230154544.GB10444@elte.hu>
In-Reply-To: <20071230154544.GB10444@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Indeed.
>> By the way, flush_cache_page() is defined as a do-while(0) on x86.
>> Would it better to define fix_riprel() as a do-while(0) on x86-32?
>> I think this obviously indicates that function has no effect.
> 
> NOPs should always be an inline. flush_cache_page()'s macro use is 
> historic - feel free to send cleanup patches against cacheflush.h.

OK, in that case, harvey's patch is good to me.

> or even better, since most architectures dont need explicit 
> cache-flushes, provide an asm-generic/cache_flush-nop.h file that is
> #include-ed by asm-x86/cacheflush.h. (and by other architectures)
> 
> 	Ingo

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


