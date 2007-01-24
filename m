Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXAXWrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXAXWrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbXAXWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:47:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:20057 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXAXWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:47:07 -0500
Date: Wed, 24 Jan 2007 14:41:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/6] per namespace tunables
Message-Id: <20070124144156.ff29d5dd.randy.dunlap@oracle.com>
In-Reply-To: <20070116063030.317602000@bull.net>
References: <20070116061516.899460000@bull.net>
	<20070116063030.317602000@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 07:15:21 +0100 Nadia.Derbey@bull.net wrote:

> [PATCH 05/06]
> 
> This patch introduces all that is needed to process per namespace tunables.
> 
> ---
>  include/linux/akt.h   |   12 +++++++
>  kernel/autotune/akt.c |   80 ++++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 73 insertions(+), 19 deletions(-)
> 
> +/*
> + * FUNCTION:    This routine gets the actual auto_tune structure for the
> + *              tunables that are per namespace (presently only ipc ones).
> + *
> + * RETURN VALUE: pointer to the tunable structure for the current namespace
> + */

Please use kernel-doc format for function comment blocks.
(see Documentation/kernel-doc-nano-HOWTO.txt)

> +static struct auto_tune *get_ns_tunable(struct auto_tune *p)
> +{
> +	if (p->flags & TUNABLE_IPC_NS) {
> +		char *shift = (char *) p;
> +		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
> +
> +		shift = (shift - (char *) &init_ipc_ns) + (char *) ns;
> +
> +		return (struct auto_tune *) shift;
> +	}
> +
> +	return p;
> +}
> +
> +
>  EXPORT_SYMBOL_GPL(register_tunable);
>  EXPORT_SYMBOL_GPL(unregister_tunable);

and put EXPORT_SYMBOL/_GPL() immediately after each function
that is being exported.

---
~Randy
