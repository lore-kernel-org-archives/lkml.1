Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZH1Eiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZH1Eiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZH1Eix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:38:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47570 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZH1Eix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:38:53 -0400
Date: Fri, 28 Aug 2009 10:08:32 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 1/6] kprobes/x86: Call BUG() when
	reentering probe into KPROBES_HIT_SS
Message-ID: <20090828043832.GC7220@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090827152539.GE6058@nowhere> <20090827172258.8246.61889.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172258.8246.61889.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:22:58PM -0400, Masami Hiramatsu wrote:
> Call BUG() when a probe have been hit on the way of kprobe processing path,
> because that kind of probes are currently unrecoverable (recovering it will
> cause an infinit loop and stack overflow).
> 
> The original code seems to assume that it will be caused by an int3 which
> another subsystem inserted on out-of-line singlestep buffer if the hitting
> probe is same as current probe. However, in that case, int3-hitting-address
> is on the out-of-line buffer and should be different from first (current)
> int3 address.
> Thus, I decided to remove the code.
> 
> I also removes arch_disarm_kprobe() because it will involve other stuffs
> in text_poke().
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
