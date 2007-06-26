Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXFZDsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXFZDsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXFZDsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:48:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53164 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbXFZDsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:48:01 -0400
Date: Tue, 26 Jun 2007 09:21:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>,
       <anil.s.keshavamurthy@intel.com>
Subject: Re: [PATCH 1/3] Make struct jprobe.entry a void *
Message-ID: <20070626035146.GA16713@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <78935473b1f70c863ab0be7d6cf4bcb04922b20b.1182822366.git.michael@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78935473b1f70c863ab0be7d6cf4bcb04922b20b.1182822366.git.michael@ellerman.id.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:48:50AM +1000, Michael Ellerman wrote:
> Currently jprobe.entry is a kprobe_opcode_t *, but that's a lie. On some
> platforms it doesn't point to an opcode at all, it points to a function
> descriptor.
> 
> It's really a pointer to something that the arch code can turn into a
> function entry point. And that's what actually happens, none of the
> generic code ever looks at jprobe.entry, it's only ever dereferenced
> by arch code.
> 
> So just make it a void *.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Tested on powerpc. Ack to all three patches plus Andrew's declaration
fixup.

Thanks Michael for the patches.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
> 
> It isn't obvious where kprobes patches should go, is anyone "the" maintainer?
> Instead I've just sent this to everyone who'd touched the code lately, or
> might be otherwise interested.
> 
> 
>  include/linux/kprobes.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 23adf60..f4e53b7 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -116,7 +116,7 @@ struct kprobe {
>   */
>  struct jprobe {
>  	struct kprobe kp;
> -	kprobe_opcode_t *entry;	/* probe handling code to jump to */
> +	void *entry;	/* probe handling code to jump to */
>  };
> 
>  DECLARE_PER_CPU(struct kprobe *, current_kprobe);
> -- 
> 1.5.1.3.g7a33b
