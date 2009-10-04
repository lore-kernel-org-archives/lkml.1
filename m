Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZJDVvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZJDVvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZJDVvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:51:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758044AbZJDVvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:51:46 -0400
Date: Sun, 4 Oct 2009 14:50:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH] connector: Keep the skb in cn_callback_data
Message-Id: <20091004145057.3de230a9.akpm@linux-foundation.org>
In-Reply-To: <1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
	<1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 16:48:08 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Please don't send unchangelogged patches.

> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 47ebf41..05a7a14 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -134,8 +134,8 @@ struct cn_callback_id {
>  struct cn_callback_data {
>  	void (*destruct_data) (void *);
>  	void *ddata;
> -	
> -	void *callback_priv;
> +
> +	struct sk_buff *skb;
>  	void (*callback) (struct cn_msg *);
>  
>  	void *free;

This one replaces the void* private pointer with the skb but you didn't
explain to us why this was done.

Also, the patch does two things.  It _adds_ the skb pointer and it also
_removes_ the opaque void* private-data pointer for the callbacks. 
What are the implications of removing callback_priv?  Why was this done?

