Return-Path: <linux-kernel-owner+w=401wt.eu-S2992893AbXCCBlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992893AbXCCBlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXCCBlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:41:40 -0500
Received: from sccrmhc12.comcast.net ([63.240.77.82]:55860 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992893AbXCCBlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:41:39 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 20:41:39 EST
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com>
References: <20070301133018.GB30177@2ka.mipt.ru>
	 <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
	 <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu>
	 <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu>
	 <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
	 <20070302193941.GB8450@elte.hu>
	 <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
	 <20070302202931.GA5101@elte.hu>
	 <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
	 <1172871820.2999.22.camel@entropy>
	 <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 17:36:01 -0800
Message-Id: <1172885761.2999.32.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 16:52 -0800, Davide Libenzi wrote:
> On Fri, 2 Mar 2007, Nicholas Miell wrote:
> 
> > The point Ingo was making is that the x86 ABI already requires the FPU
> > context to be saved before *all* function calls.
> 
> I've not seen that among Ingo's points, but yeah some status is caller 
> saved. But, aren't things like status word and control bits callee saved? 
> If that's the case, it might require proper handling.
> 

Ingo mentioned it in one of the parts you cut out of your reply:

> and here is where thinking about threadlets as a function call and not 
> as an asynchronous context helps alot: the classic gcc convention for 
> FPU use & function calls should apply: gcc does not call an external 
> function with an in-use FPU stack/register, it always neatly unuses it, 
> as no FPU register is callee-saved, all are caller-saved.

The i386 psABI is ancient (i.e. it predates SSE, so no mention of the
XMM or MXCSR registers) and a bit vague (no mention at all of the FP
status word), but I'm fairly certain that Ingo is right.


-- 
Nicholas Miell <nmiell@comcast.net>

