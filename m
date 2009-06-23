Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbZFWIzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbZFWIzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZFWIze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:55:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:35844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbZFWIzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:55:33 -0400
Date: Tue, 23 Jun 2009 10:55:35 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Alex Riesen <raa.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tom Talpey <tmtalpey@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] Use formatting of module name in SUNRPC
In-Reply-To: <20090527175955.GB8969@blimp.localdomain>
Message-ID: <alpine.LNX.2.00.0906231054570.7457@wotan.suse.de>
References: <20090527175955.GB8969@blimp.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Alex Riesen wrote:

> Besides, the old code caused gcc-4.3.3 to produce the warning:
>   "format not a string literal and no format arguments"
> 
> Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
> ---
>  net/sunrpc/xprt.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index 06ca058..82f62fd 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -162,7 +162,6 @@ EXPORT_SYMBOL_GPL(xprt_unregister_transport);
>  int xprt_load_transport(const char *transport_name)
>  {
>  	struct xprt_class *t;
> -	char module_name[sizeof t->name + 5];
>  	int result;
>  
>  	result = 0;
> @@ -174,9 +173,7 @@ int xprt_load_transport(const char *transport_name)
>  		}
>  	}
>  	spin_unlock(&xprt_list_lock);
> -	strcpy(module_name, "xprt");
> -	strncat(module_name, transport_name, sizeof t->name);
> -	result = request_module(module_name);
> +	result = request_module("xprt%s", transport_name);
>  out:
>  	return result;
>  }

Trond, are you planning to take this one through your tree?

Thanks,

-- 
Jiri Kosina
SUSE Labs

