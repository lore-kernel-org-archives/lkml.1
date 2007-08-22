Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbXHVQSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbXHVQSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764840AbXHVQSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:18:30 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:38269 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764762AbXHVQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:18:29 -0400
Date: Wed, 22 Aug 2007 12:18:28 -0400
From: Nick Bowler <nbowler@ellipticsemi.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?G=E9lineau=2CSamuel_=5BMontreal=5D?= 
	<samuel.gelineau@EC.GC.CA>
Subject: Re: Patch for Apani Nortel VPN Client to build against kernel 2.6.22  help/review
Message-ID: <20070822161828.GA16063@totient.ellipticsemi.com>
Mail-Followup-To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
	linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?G=E9lineau=2CSamuel_=5BMontreal=5D?= <samuel.gelineau@EC.GC.CA>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128B34@ecqcmtlmail3.quebec.int.ec.gc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128B34@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't read too much into the patch, but some quick comments.  Most applies
throughout:

> +#if (LINUX_VERSION_CODE >= 0x020616)
KERNEL_VERSION(2,6,22) is much more readable than 0x020616.

> +  return (struct iphdr*) skb->network_header;
Should be return ip_hdr(skb);

> +    skb->network_header = skb->data;
Should be skb_reset_network_header(skb);

> +    iph = skb->network_header.iph;
Probably meant skb->nh.iph.

> +  if ( iph->protocol == 17 )            /* if UDP, */
(snip)
> +  if ( iph->protocol == 6 )             /* if TCP, */
Could use IPPROTO_UDP and IPPROTO_TCP instead of 17 and 6, respectively.

Instead of littering the code with #if blah #else blah, you could also simply
provide implementations for the 2.6.22 functions #if LINUX_VERSION_CODE <
KERNEL_VERSION(2,6,22).

-- 
Nick Bowler, Elliptic Semiconductor (http://www.ellipticsemi.com/)

