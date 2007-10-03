Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXJCSoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXJCSoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXJCSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:44:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52480 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXJCSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:44:09 -0400
In-Reply-To: <ada1wcxnev5.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF9591AF85.09F0D1BF-ON87257369.006651BA-88257369.0066A0BD@us.ibm.com>
From: Shirley Ma <xma@us.ibm.com>
Date: Wed, 3 Oct 2007 11:43:40 -0700
X-MIMETrack: Serialize by Router on D03MC012/03/M/IBM(Release 7.0.2FP2HF51 | June 19, 2007) at
 10/03/2007 12:44:01,
	Serialize complete at 10/03/2007 12:44:01
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 09/17/2007 02:47:42 PM:

>  > > IPoIB CM handles this properly by gathering together single pages 
in
>  > > skbs' fragment lists.
> 
>  > Then can we reuse IPoIB CM code here?
> 
> Yes, if possible, refactoring things so that the rx skb allocation
> code becomes common between CM and non-CM would definitely make sense.

IPoIB-CM rx skb allocation is not generic to be used by UD, it allocates 
more buffers than needed if mtu is not 64K, and doesn't query the real 
max_num_sg from the device. I am thinking to have a generic skb allocation 
in IPoIB based on matrix of (ipoib-mtu-size, page-size, max_num_sg, 
head-size).

Thanks
Shirley 
