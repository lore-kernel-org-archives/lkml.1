Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZGFOfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZGFOfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZGFOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:34:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZGFOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:34:55 -0400
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -tip -v10 5/7] x86: add pt_regs register and stack access APIs
From: Andi Kleen <andi@firstfloor.org>
References: <20090701010838.32547.62843.stgit@localhost.localdomain>
	<20090701010911.32547.1313.stgit@localhost.localdomain>
Date: Mon, 06 Jul 2009 16:34:53 +0200
In-Reply-To: <20090701010911.32547.1313.stgit@localhost.localdomain> (Masami Hiramatsu's message of "Tue, 30 Jun 2009 21:09:11 -0400")
Message-ID: <871votop6a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:

> Add following APIs for accessing registers and stack entries from pt_regs.

You forgot to state who calls these functions/why are they added?
Who only has strings for registers?

I can see the point of having a function for nth argument though,
that's useful.

> +static inline unsigned long regs_get_argument_nth(struct pt_regs *regs,
> +						  unsigned n)
> +{
> +	if (n < NR_REGPARMS) {
> +		switch (n) {
> +		case 0:
> +			return regs->ax;
> +		case 1:
> +			return regs->dx;
> +		case 2:
> +			return regs->cx;


[....]

That could be done shorter with a offsetof table.

> +	if (n < NR_REGPARMS) {
> +		switch (n) {
> +		case 0:
> +			return regs->di;
> +		case 1:
> +			return regs->si;
> +		case 2:
> +			return regs->dx;
> +		case 3:
> +			return regs->cx;
> +		case 4:
> +			return regs->r8;
> +		case 5:
> +			return regs->r9;

and that too.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
