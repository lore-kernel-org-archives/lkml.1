Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0CCTSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:18:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:57327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0CCTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:18:34 -0500
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: eranian@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       paulus@samba.org, robert.richter@amd.com, fweisbec@gmail.com
In-Reply-To: <20100303.095553.105186917.davem@davemloft.net>
References: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
	 <1267637995.25158.96.camel@laptop>
	 <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
	 <20100303.095553.105186917.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 20:18:30 +0100
Message-ID: <1267643910.25158.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 09:55 -0800, David Miller wrote:
> From: Stephane Eranian <eranian@google.com>
> Date: Wed, 3 Mar 2010 09:49:33 -0800
> 
> > On Wed, Mar 3, 2010 at 9:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Wed, 2010-03-03 at 09:30 -0800, Stephane Eranian wrote:
> >>> This assumes struct pt_regs is somehow exported to userland.
> >>> Is that the case?
> >>
> >> I seems to have understood they were, and asm/ptrace.h seems to agree
> >> with that, it has !__KERNEL__ definitions for struct pt_regs.
> >>
> > Seems to be the case, indeed.
> 
> BTW, how are you going to cope with compat systems?
> 
> If I build 'perf' on a sparc64 kernel build, it's going to get the
> 64-bit pt_regs.  So I can't then use that binary on a sparc box
> running a 32-bit kernel.
> 
> And vice versa.
> 
> And more generally aren't we supposed to be able to eventually analyze
> perf dumps on any platform not just the one 'perf' was built under?
> 
> We'll need to do something about the encoding of pt_regs, therefore.

Hrm, yes,.. what I can do for the moment is 'cheat' and make the raw
PEBS record available through PERF_SAMPLE_RAW (that also has CAP_ADMIN,
which I guess is a good idea for full reg sets), and then we can work
out how to expose pt_regs later.

If someone has a better suggestion than this, which is basically blurp
out host native pt_regs and cope, please tell ;-)

