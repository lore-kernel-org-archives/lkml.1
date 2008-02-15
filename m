Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbYBOU0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbYBOU0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760388AbYBOUZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:25:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:50448 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbYBOUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:25:53 -0500
Message-ID: <47B5F518.3000708@windriver.com>
Date: Fri, 15 Feb 2008 14:24:56 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [RFC][PATCH] modular kgdb-light
References: <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org> <20080212170711.GB4191@one.firstfloor.org> <47B58718.9020105@siemens.com> <20080215133238.GA28942@one.firstfloor.org>
In-Reply-To: <20080215133238.GA28942@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 20:24:31.0327 (UTC) FILETIME=[C5604EF0:01C87010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Feb 15, 2008 at 01:35:36PM +0100, Jan Kiszka wrote:
>   
>>  o machine_emergency_restart - for implementing "R0" gdb packet
>>     
>
> Hmm, might be a bit dangerous to call this directly -- there are various
> quirks with e.g. not rebooting on CPU #0 and not resetting APIC 
> state. But ok [this is not directly related to the fact that it's
> exported now, just mentioning this in general]
>
>   
kgdb was never expected to be any better than using a sysrq-b.   Unless
you put some really ugly code in to deal with lots of edge cases there
are certainly times it is just going to force you to press the power
button.  If there is a better function for "reset now and cross fingers"
kgdb can be changed easily enough to do that.

Also given that you can have more than one type of "R" packet it would
be easy enough to add other reboot types, such as an R1 which might call
to the bios or another means to reset.  For now the intent is pretty
clear and there is not likely a need to expand the scope.

Jason.
