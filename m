Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbXITTtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbXITTtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXITTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:49:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2590 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXITTtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:49:17 -0400
Date: Thu, 20 Sep 2007 21:48:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070920194813.GH10199@1wt.eu>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu> <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> <1190183324.9737.7.camel@Homer.simpson.net> <1190188261.9185.21.camel@Homer.simpson.net> <1190191368.8687.5.camel@Homer.simpson.net> <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com> <1190264114.6411.4.camel@Homer.simpson.net> <1190272507.27867.20.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190272507.27867.20.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 09:15:07AM +0200, Mike Galbraith wrote:
> But, I did just manage to trigger some horrid behavior, and log it.  I
> modified the kernel to print task's actual tree key instead of their
> current vruntime, and was watching that while make -j2 was running (and
> not seeing anything very interesting), when on a lark, I restarted
> SuSE's system updater thingy.  That beast chews 100% CPU for so long at
> startup that I long ago got annoyed, and changed it to run at nice 19.
> Anyway, when it started, interactivity went to hell in the proverbial
> hand-basket, and the sched_debug log shows some interesting results..
> like spread0 hitting -13659412644, and cc1 being keyed at -3867063305.
> 
> cpu#0, 2992.608 MHz
>   .nr_running                    : 4
>   .load                          : 4096
>   .nr_switches                   : 1105882
>   .nr_load_updates               : 735146
>   .nr_uninterruptible            : 4294966399

(...)

> cpu#1, 2992.608 MHz
>   .nr_running                    : 5
>   .load                          : 6208
>   .nr_switches                   : 1012995
>   .nr_load_updates               : 747540
>   .nr_uninterruptible            : 897

I don't know if this is relevant, but 4294966399 in nr_uninterruptible
for cpu#0 equals -897, exactly the negation of cpu1.nr_uninterruptible.
I don't know if this rings a bell for someone or if it's a completely
useless comment, but just in case...

HTH,
Willy

