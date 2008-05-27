Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYE0Vm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYE0Vm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759872AbYE0Vmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:42:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758691AbYE0Vma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:42:30 -0400
Date: Tue, 27 May 2008 14:40:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] debug printk infrastructure -compile fixes
Message-Id: <20080527144023.bf47e3e6.akpm@linux-foundation.org>
In-Reply-To: <20080522211639.GD28070@redhat.com>
References: <20080522211639.GD28070@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 17:16:39 -0400
Jason Baron <jbaron@redhat.com> wrote:

> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  net/netfilter/nf_conntrack_pptp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
> index 97e54b0..7fea304 100644
> --- a/net/netfilter/nf_conntrack_pptp.c
> +++ b/net/netfilter/nf_conntrack_pptp.c
> @@ -65,7 +65,7 @@ void
>  			     struct nf_conntrack_expect *exp) __read_mostly;
>  EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
>  
> -#ifdef DEBUG
> +#if defined(DEBUG) || defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
>  /* PptpControlMessageType names */
>  const char *const pptp_msg_name[] = {
>  	"UNKNOWN_MESSAGE",

Does this imply that the patch series will break bisectability?  If so,
this fix should be merged into whichever patch introduces the build
breakage.

