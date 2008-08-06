Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbYHFUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbYHFUoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYHFUn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:43:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51289 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYHFUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:43:58 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5204932"
Message-ID: <489A0D0C.1000204@qualcomm.com>
Date: Wed, 06 Aug 2008 13:43:56 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: rakib.mullick@gmail.com, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset : Handling improper memory allocation.
References: <b9df5fa10808061022r34e3a009k5060c8fab06bcd5c@mail.gmail.com>	<489A05EF.7000108@qualcomm.com> <20080806153700.dc12e5dc.pj@sgi.com>
In-Reply-To: <20080806153700.dc12e5dc.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> partition_sched_domains() can deal with attrs==NULL case. So we do not
>> have to abort domain building.
> 
> This might be a good place for a comment, since unchecked kmalloc()
> calls look dangerous:
> 
> 	/* Convert <csn, csa> to <ndoms, doms> */
> 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
> 	if (!doms)
> 		goto rebuild;
> 	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
> 	/* dattr == NULL is ok; partition_sched_domains() can cope with it. */

Makes sense. I'll add it, since I'm touching that area anyway.

Max


