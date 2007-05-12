Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbXELSKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbXELSKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXELSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:09:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48028 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbXELSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:09:46 -0400
Message-ID: <464602DC.4050603@zytor.com>
Date: Sat, 12 May 2007 11:09:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>	<1178806235.18785.1189115515@webmail.messagingengine.com>	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com> <m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> HPA is both right and wrong on this.  The safe sequence for entering
> protected mode requires a jump immediately after setting PE in %cr0.
> To serialize the instruction stream and to be on an execution that
> is tested and guaranteed to work in cpus.
> 

Eric, that's complete nonsense.  What Intel documents and what Intel
tests are two very different things.

Intel appears to be afraid of what they call "the crack", but the
semantics of the transition are quite well understood.

> On a lot of processors you can get away with more then that, but
> Intel at least explicitly states in their "Software Developers Manual
> Volume 3: System Programming" in 9.9.1 "Switching to Protected Mode"
> that you need the jump immediately following enabling PE in cr0.
> 
> So while I was debugging and instrumenting code I would happily
> place an instruction before the jump so I could get output.
> However in production grade code I would not place anything
> between the setting of PE in cr0 and the first jump instruction.

A lot of the Intel manuals are boilerplate written by technical writers.
 Once you're used to them you can spot it quite easily because it's
carried from generation to generation with little change, even when it's
blatantly obsoleted.

I can tell you there is tons of production code out there which *never*
reloads CS after switching into and out of protected mode.  It just
plain has to work, on every x86 CPU ever made, with the obvious
semantics.  With Intel's VT, you want to avoid sticking in that mode for
extended periods of time, for performance reasons, but it will work even
there (it kicks to interpreter, though.)  Staying long enough to load
the segment registers is not an issue.

	-hpa
