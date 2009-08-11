Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZHKMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZHKMGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZHKMGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:06:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZHKMGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:06:43 -0400
Message-ID: <4A815B9A.3060205@redhat.com>
Date: Tue, 11 Aug 2009 14:52:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix memory leak in virtio_net
References: <1249934708.7400.10.camel@localhost.localdomain>
In-Reply-To: <1249934708.7400.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying Rusty, the virtio maintainer)

On 08/10/2009 11:05 PM, Shirley Ma wrote:
> Whild reading virtio code, I found some memory leak in removing
> virtio_net.
>
> In virtnet_remove, only skb has been freed not the pages in skb
> frags. Here is the patch to fix this, please review it.
>
>    

There were indeed reports of virtio ooming; this might be the cause.

> Signed-off-by: Shirley Ma<xma@us.ibm.com>
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2a6e81d..7e629d9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -978,6 +978,7 @@ static void virtnet_remove(struct virtio_device *vdev)
>
>   	/* Free our skbs in send and recv queues, if any. */
>   	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
> +		trim_pages(vi, skb);
>   		kfree_skb(skb);
>   		vi->num--;
>   	}
>
>
>
>
>    


-- 
error compiling committee.c: too many arguments to function

