Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXHTAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXHTAT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXHTATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:19:46 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2354 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705AbXHTATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:19:45 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: felix@chelsio.com (Felix Marti)
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Cc: davem@davemloft.net, sean.hefty@intel.com, netdev@vger.kernel.org,
       rdreier@cisco.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Organization: Core
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IMuyW-0002FV-00@gondolin.me.apana.org.au>
Date: Mon, 20 Aug 2007 08:18:32 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Marti <felix@chelsio.com> wrote:
>
> [Felix Marti] Aren't you confusing memory and bus BW here? - RDMA 
> enables DMA from/to application buffers removing the user-to-kernel/
> kernel-to-user memory copy with is a significant overhead at the 
> rates we're talking about: memory copy at 20Gbps (10Gbps in and 10Gbps 
> out) requires 60Gbps of BW on most common platforms. So, receiving and
> transmitting at 10Gbps with LRO and TSO requires 80Gbps of system 
> memory BW (which is beyond what most systems can do) whereas RDMA can 
> do with 20Gbps!

Actually this is false.  TSO only requires a copy if the user
chooses to use the sendmsg interface instead of sendpage.  The
same is true for RDMA really.  Except that instead of having to
switch your application to sendfile/splice, you're switching it
to RDMA.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
