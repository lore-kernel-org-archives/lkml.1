Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXA3F4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXA3F4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 00:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXA3F4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 00:56:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbXA3F4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 00:56:09 -0500
Date: Tue, 30 Jan 2007 11:25:56 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Paul Mackerras <paulus@samba.org>,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] kprobes: Fix compiler warning
Message-ID: <20070130055556.GA20699@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:43:33PM -0600, Kumar Gala wrote:
> On ppc the compiler gripes about:
> 
> kernel/kprobes.c: In function 'collect_garbage_slots':
> kernel/kprobes.c:215: warning: comparison is always false due to limited 
> range of data type
> 
> The compiler ends up optimizing away the test since char's are unsigned on 
> ppc.

Kumar,

Masami fixed this last week:

http://marc.theaimsgroup.com/?l=linux-kernel&m=116968723823366&w=2

Patch currently in -mm.

Thanks,
Ananth

> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> ---
> commit 1ee2dc5300b1c454f92eeea82da300f72db1b26f
> tree c73cdacb43e154292708d967e11b1cbf7ab4904f
> parent c0d4d573feed199b16094c072e7cb07afb01c598
> author Kumar Gala <galak@kernel.crashing.org> Mon, 29 Jan 2007 23:38:11 
> -0600
> committer Kumar Gala <galak@kernel.crashing.org> Mon, 29 Jan 2007 23:38:11 
> -0600
> 
>  kernel/kprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 17ec4af..514276f 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -212,7 +212,7 @@ static int __kprobes collect_garbage_slots(void)
>  			continue;
>  		kip->ngarbage = 0;	/* we will collect all garbages */
>  		for (i = 0; i < INSNS_PER_PAGE; i++) {
> -			if (kip->slot_used[i] == -1 &&
> +			if (kip->slot_used[i] == (char)-1 &&
>  			    collect_one_slot(kip, i))
>  				break;
>  		}
