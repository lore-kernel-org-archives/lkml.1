Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZGXPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZGXPgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZGXPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:36:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZGXPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:36:31 -0400
Date: Fri, 24 Jul 2009 08:36:07 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: davem@davemloft.net, bridge@lists.linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [PATCH] net/bridge: use kobject_put to release kobject in
 br_add_if error path
Message-ID: <20090724083607.6b91282d@nehalam>
In-Reply-To: <1248426392-30777-1-git-send-email-dfeng@redhat.com>
References: <1248426392-30777-1-git-send-email-dfeng@redhat.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 17:06:32 +0800
Xiaotian Feng <dfeng@redhat.com> wrote:

> kobject_init_and_add will alloc memory for kobj->name, so in br_add_if
> error path, simply use kobject_del will not free memory for kobj->name.
> Fix by using kobject_put instead, kobject_put will internally calls
> kobject_del and frees memory for kobj->name.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  net/bridge/br_if.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 8a96672..eb404dc 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -424,7 +424,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
>  err2:
>  	br_fdb_delete_by_port(br, p, 1);
>  err1:
> -	kobject_del(&p->kobj);
> +	kobject_put(&p->kobj);
>  err0:
>  	dev_set_promiscuity(dev, -1);
>  put_back:

I assume you tested this by doing something like adding two interfaces
with the same MAC address to a bridge.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>

-- 
