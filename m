Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZFBRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZFBRmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZFBRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:42:39 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:42431 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbZFBRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:42:38 -0400
Message-ID: <4A256462.10600@gmail.com>
Date: Tue, 02 Jun 2009 13:41:54 -0400
From: Tom Talpey <tmtalpey@gmail.com>
MIME-Version: 1.0
To: Alex Riesen <raa.lkml@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] Use formatting of module name in SUNRPC
References: <20090527175955.GB8969@blimp.localdomain>
In-Reply-To: <20090527175955.GB8969@blimp.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2009 1:59 PM, Alex Riesen wrote:
> Besides, the old code caused gcc-4.3.3 to produce the warning:
>    "format not a string literal and no format arguments"
>
> Signed-off-by: Alex Riesen<raa.lkml@gmail.com>
> ---
>   net/sunrpc/xprt.c |    5 +----
>   1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index 06ca058..82f62fd 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -162,7 +162,6 @@ EXPORT_SYMBOL_GPL(xprt_unregister_transport);
>   int xprt_load_transport(const char *transport_name)
>   {
>   	struct xprt_class *t;
> -	char module_name[sizeof t->name + 5];
>   	int result;
>
>   	result = 0;
> @@ -174,9 +173,7 @@ int xprt_load_transport(const char *transport_name)
>   		}
>   	}
>   	spin_unlock(&xprt_list_lock);
> -	strcpy(module_name, "xprt");
> -	strncat(module_name, transport_name, sizeof t->name);
> -	result = request_module(module_name);
> +	result = request_module("xprt%s", transport_name);
>   out:
>   	return result;
>   }

Never saw the warning while compiling, but I'm fine with the
proposed change, besides, it's cleaner. Ack.

Tom.

