Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbXLQPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbXLQPai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXLQPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:30:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbXLQPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:30:29 -0500
Message-ID: <476695D9.8090904@redhat.com>
Date: Mon, 17 Dec 2007 10:29:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: Final kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu> <4766841B.1040500@redhat.com> <20071217143050.GA13290@elte.hu>
In-Reply-To: <20071217143050.GA13290@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> Masami,
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hi Harvey and Ingo,
>>
>> I'm working on another version of patches for unification.
>> Currently cleaning up the patches.
>> http://sources.redhat.com/ml/systemtap/2007-q4/msg00457.html
>> I'll cleanup and repost it today.
> 
> cool! Please Cc: lkml and Harvey as well so that there's less overlap in 
> unification work - Harvey spent quite some time unifying and cleaning up 
> the kprobes code during the past week.

Should I rewrite it based on current git tree?
My patch includes 3 part of patches.
- 2 Bugfix patches (which is not merged yet.)
- 2 booster patches (ditto)
- 2 unification patches (most of this patches are already done by Harvey's patch)

> 
> So i think we could/should use Harvey's latest series as a base, those 
> are pretty finegrained already. Note that they break 64-bit kprobes 
> though, with such a config:
> 
>  CONFIG_KPROBES=y
>  CONFIG_NET_TCPPROBE=y
> 
> so it crashes with an int3 in the TCP code. It's probably some trivial 
> typo somewhere, as 32-bit works fine.
> 
> the coordinates for x86.git#mm can be found below - that tree already 
> includes Harvey's latest kprobes series. I'll try to bisect the 64-bit 
> breakage now.
> 
> 	Ingo
> 
> ------------------>
>  git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
>  cd linux-2.6.git
>  git-branch x86
>  git-checkout x86
>  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
> 
> (do subsequent pulls via "git-pull --force", as we frequently rebase the
> git tree. NOTE: this might override your own local changes, so do this
> only if you dont mind about losing thse changes in that tree.)
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

