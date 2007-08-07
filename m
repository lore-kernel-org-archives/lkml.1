Return-Path: <linux-kernel-owner+w=401wt.eu-S934411AbXHGPGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbXHGPGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXHGPGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:06:31 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:35263 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbXHGPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:06:30 -0400
Message-ID: <46B88A75.3040004@opengridcomputing.com>
Date: Tue, 07 Aug 2007 10:06:29 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Roland Dreier <rdreier@cisco.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sean Hefty <sean.hefty@intel.com>,
       OpenFabrics General <general@lists.openfabrics.org>
Subject: Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP
 port space.
References: <46B883B5.8040702@opengridcomputing.com> <20070807145441.GA24895@2ka.mipt.ru>
In-Reply-To: <20070807145441.GA24895@2ka.mipt.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Evgeniy Polyakov wrote:
> Hi Steve.
> 
> On Tue, Aug 07, 2007 at 09:37:41AM -0500, Steve Wise (swise@opengridcomputing.com) wrote:
>> +static int cma_get_tcp_port(struct rdma_id_private *id_priv)
>> +{
>> +	int ret;
>> +	struct socket *sock;
>> +
>> +	ret = sock_create_kern(AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
>> +	if (ret)
>> +		return ret;
>> +	ret = sock->ops->bind(sock,
>> +			  (struct socketaddr 
>> *)&id_priv->id.route.addr.src_addr,
>> +			  ip_addr_size(&id_priv->id.route.addr.src_addr));
> 
> If get away from talks about broken offloading, this one will result in
> the case, when usual network dataflow can enter private rdma land, i.e.
> after bind succeeded this socket is accessible via any other network
> device. Is it inteded?
> And this is quite noticeble overhead per rdma connection, btw.
> 

I'm not sure I understand your question?  What do you mean by 
"accessible"?  The intention is to _just_ reserve the addr/port.  
The socket struct alloc and bind was a simple way to do this.  I 
assume we'll have to come up with a better way though.  
Namely provide a low level interface to the port space allocator 
allowing both rdma and the host tcp stack to share the space without
requiring a socket struct for rdma connections. 

Or maybe we'll come up a different and better solution to this issue...

Steve.
