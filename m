Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYCYPCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYCYPCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYCYPCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:02:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754770AbYCYPCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:02:31 -0400
Message-ID: <47E91404.7030901@sgi.com>
Date: Tue, 25 Mar 2008 08:02:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] net: remove NR_CPUS arrays in net/core/dev.c
References: <20080325021954.979158000@polaris-admin.engr.sgi.com> <20080325021956.212787000@polaris-admin.engr.sgi.com> <20080325055752.GA4774@martell.zuzino.mipt.ru>
In-Reply-To: <20080325055752.GA4774@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Mar 24, 2008 at 07:20:02PM -0700, Mike Travis wrote:
>> Remove the fixed size channels[NR_CPUS] array in
>> net/core/dev.c and dynamically allocate array based on
>> nr_cpu_ids.
> 
>> @@ -4362,6 +4362,13 @@ netdev_dma_event(struct dma_client *clie
>>   */
>>  static int __init netdev_dma_register(void)
>>  {
>> +	net_dma.channels = kzalloc(nr_cpu_ids * sizeof(struct net_dma),
>> +								GFP_KERNEL);
>> +	if (unlikely(net_dma.channels)) {
> 
> 		     !net_dma.channels
> 
>> +		printk(KERN_NOTICE
>> +				"netdev_dma: no memory for net_dma.channels\n");
>> +		return -ENOMEM;
>> +	}


Got it, Thanks!  

-Mike
