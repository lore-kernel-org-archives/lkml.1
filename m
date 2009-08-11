Return-Path: <linux-kernel-owner+w=401wt.eu-S1751272AbZHKLxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbZHKLxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZHKLxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:53:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47296 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZHKLxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:53:13 -0400
Subject: Re: [PATCH] fix memory leak in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1249934708.7400.10.camel@localhost.localdomain>
References: <1249934708.7400.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 22:03:41 -0700
Message-Id: <1249967021.4161.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is false report. I checked kfree_skb(), it does free all pages 
in the fraglist in skb_release_data() later.

Thanks
Shirley

On Mon, 2009-08-10 at 13:05 -0700, Shirley Ma wrote:
> Whild reading virtio code, I found some memory leak in removing
> virtio_net.
> 
> In virtnet_remove, only skb has been freed not the pages in skb
> frags. Here is the patch to fix this, please review it.
> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2a6e81d..7e629d9 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -978,6 +978,7 @@ static void virtnet_remove(struct virtio_device *vdev)
> 
>  	/* Free our skbs in send and recv queues, if any. */
>  	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
> +		trim_pages(vi, skb);
>  		kfree_skb(skb);
>  		vi->num--;
>  	}
> 
> 
> 
> 

