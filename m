Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXB1J3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXB1J3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXB1J3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:29:32 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:56321 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbXB1J3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:29:31 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] ehea: NAPI multi queue TX/RX path for SMP
Date: Wed, 28 Feb 2007 10:23:16 +0100
User-Agent: KMail/1.8.2
Cc: Jeff Garzik <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200702271732.51829.ossthema@de.ibm.com> <45E46208.3000003@trash.net>
In-Reply-To: <45E46208.3000003@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281023.17591.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >  
> > +static inline int ehea_hash_skb(struct sk_buff *skb, int num_qps)
> > +{
> > +	u32 tmp;
> > +	if ((skb->nh.iph->protocol == IPPROTO_TCP)
> > +	    && skb->protocol == ETH_P_IP) {
> 
> skb->protocol has network byte order. The ETH_P_IP test should also
> logically come before checking the IP protocol.
> 

fixed.

> > +		tmp = (skb->h.th->source + (skb->h.th->dest << 16)) % 31;
> 
> Only locally generated packets have a valid h.th pointer.
> 
good point. I'll fix that.

I'll send a new patch set later today

Thanks,
Jan-Bernd
