Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXHGOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXHGOzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXHGOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:55:03 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37226 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbXHGOzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:55:01 -0400
Date: Tue, 7 Aug 2007 18:54:41 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sean Hefty <sean.hefty@intel.com>,
       OpenFabrics General <general@lists.openfabrics.org>
Subject: Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
Message-ID: <20070807145441.GA24895@2ka.mipt.ru>
References: <46B883B5.8040702@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B883B5.8040702@opengridcomputing.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve.

On Tue, Aug 07, 2007 at 09:37:41AM -0500, Steve Wise (swise@opengridcomputing.com) wrote:
> +static int cma_get_tcp_port(struct rdma_id_private *id_priv)
> +{
> +	int ret;
> +	struct socket *sock;
> +
> +	ret = sock_create_kern(AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
> +	if (ret)
> +		return ret;
> +	ret = sock->ops->bind(sock,
> +			  (struct socketaddr 
> *)&id_priv->id.route.addr.src_addr,
> +			  ip_addr_size(&id_priv->id.route.addr.src_addr));

If get away from talks about broken offloading, this one will result in
the case, when usual network dataflow can enter private rdma land, i.e.
after bind succeeded this socket is accessible via any other network
device. Is it inteded?
And this is quite noticeble overhead per rdma connection, btw.

-- 
	Evgeniy Polyakov
