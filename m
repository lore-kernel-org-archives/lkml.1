Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZKTGUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZKTGUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZKTGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:20:21 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:48429 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZKTGUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:20:21 -0500
Message-ID: <4B063509.10006@gmail.com>
Date: Fri, 20 Nov 2009 07:19:53 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers and
 big packets in virtio_net
References: <1258697745.7416.20.camel@localhost.localdomain>
In-Reply-To: <1258697745.7416.20.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 20 Nov 2009 07:19:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shirley Ma a écrit :
> This patch is generated against 2.6 git tree. I didn't break up this
> patch since it has one functionality. Please review it.
> 
> Thanks
> Shirley
> 
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ------
>  
> +void virtio_free_pages(void *buf)
> +{
> +	struct page *page = (struct page *)buf;
> +
> +	while (page) {
> +		__free_pages(page, 0);
> +		page = (struct page *)page->private;
> +	}
> +}
> +

Interesting use after free :)
