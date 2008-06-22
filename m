Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYFVVSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYFVVSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYFVVS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:18:29 -0400
Received: from mga10.intel.com ([192.55.52.92]:32437 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755972AbYFVVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,686,1204531200"; 
   d="scan'208";a="344368932"
Message-ID: <485EC1A1.1020503@linux.intel.com>
Date: Sun, 22 Jun 2008 14:18:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq softlockup debugging
References: <20080622122845.GA10133@damson.getinternet.no>
In-Reply-To: <20080622122845.GA10133@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:

Hi

I like the general idea a lot; some comments below on the patch
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index f1fc747..97d47cf 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -296,6 +296,9 @@ extern void softirq_init(void);
>  extern void raise_softirq_irqoff(unsigned int nr);
>  extern void raise_softirq(unsigned int nr);
>  
> +#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
> +extern void *get_last_softirq_action(int cpu);
> +#endif

you don't need to ifdef prototypes....
(there's only one exception: if the prototype uses types that are ifdef'd themselves, but that's not here)


In general... I don't like that this is a config option. I mean... is there a really strong
reason why this shouldn't just always be there?
