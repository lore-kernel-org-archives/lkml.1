Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZHIDcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZHIDcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 23:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZHIDcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 23:32:51 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:51488 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbZHIDcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 23:32:50 -0400
X-Trace: 243232001/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.64.200/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.64.200
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANPffUpPRUDI/2dsb2JhbACBUswghBgF
X-IronPort-AV: E=Sophos;i="4.43,348,1246834800"; 
   d="scan'208";a="243232001"
Date: Sun, 9 Aug 2009 04:32:28 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
In-Reply-To: <20090808235634.GB6866@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
 <20090808235634.GB6866@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009, Paul E. McKenney wrote:
> On Sat, Aug 08, 2009 at 08:34:03PM +0100, Hugh Dickins wrote:
> 
> > CONFIG_PREEMPT_TREE=y seems okay on PowerPC; and when I briefly tried
> 
> CONFIG_TREE_RCU=y, you mean, right?

Whoops, yes indeed.

> > My guess is that there's some other issue which is triggering
> > the RCU disgrace, but that is just a guess.
> 
> The one other issue I know of is one that apparently happens only on
> one of Ingo's machines, which suddenly decides that it need not inform
> RCU when onlining a CPU (at boot time).
> 
> But you seem to be making it past boot, and I would guess that you are
> not doing any hotplug CPU operations, right?

That's right, I'm well past boot, and don't explicitly get into CPU
hotplug, nor using suspend/hibernate on that machine; and looking at
the config, see I don't even have CONFIG_HOTPLUG_CPU set.

In the morning I'll check that /proc/cpuinfo really shows all four
cpus before I start, and is still showing four cpus when it goes bad,
in case there's nevertheless an issue with that.

Is there some particular attribute of a cpu, most relevant to its RCU
grace status, that I can check on with a printk?

> 
> > Config attached.  Any suggestions?

[ Of course I forgot the config, but sent it just to Paul later. ]

> 
> /me scratches head...  Will try some more CONFIG_PREEMPT_RCU testing
> locally.

Thanks: I'm kind of glad that it's interesting,
though it may sink some of our time.

Hugh
