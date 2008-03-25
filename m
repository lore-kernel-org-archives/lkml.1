Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYCYGAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYCYGAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYCYGAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:00:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:58157 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbYCYGAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rxvF/QUO0XeSCw8BPx1tUNlOhQilRil/4LtLxg0UOxzO3JKpX0dQrCxeCvXxlPgOlDzb+UrvSLA7LcMPBSSUEc2sRVTkkEPPmjvBortwoziP4FyYeAvpT805Vk03oOcVPzV7Zcar5/O22+/MQkGhlzcXMLw+JdAg+eg8YfQ6t8o=
Date: Tue, 25 Mar 2008 08:57:52 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] net: remove NR_CPUS arrays in net/core/dev.c
Message-ID: <20080325055752.GA4774@martell.zuzino.mipt.ru>
References: <20080325021954.979158000@polaris-admin.engr.sgi.com> <20080325021956.212787000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325021956.212787000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 07:20:02PM -0700, Mike Travis wrote:
> Remove the fixed size channels[NR_CPUS] array in
> net/core/dev.c and dynamically allocate array based on
> nr_cpu_ids.

> @@ -4362,6 +4362,13 @@ netdev_dma_event(struct dma_client *clie
>   */
>  static int __init netdev_dma_register(void)
>  {
> +	net_dma.channels = kzalloc(nr_cpu_ids * sizeof(struct net_dma),
> +								GFP_KERNEL);
> +	if (unlikely(net_dma.channels)) {

		     !net_dma.channels

> +		printk(KERN_NOTICE
> +				"netdev_dma: no memory for net_dma.channels\n");
> +		return -ENOMEM;
> +	}

