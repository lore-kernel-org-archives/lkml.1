Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYHUHbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYHUHbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYHUHbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:31:34 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:24565 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYHUHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=d7gWsa1vZ29ZOJ9JyMHb8iUf8KcxpJnKjDFl6qp8RSKBUxa1u9oPhHOR4TVxU6vfPd
         IVCqFGqif6NDu6cKTtwvAhcC/HRv1Da2fK0Av1OT/9SqWU4c7y2EZLAzWw9MBL7xuWb+
         5Cqx/ne5RUZKWifBY2U0lSSDJjDdTIIqJQMBI=
Message-ID: <2f11576a0808210031r372c12bau7c94d86f2c9120d4@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:31:31 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <20080821002757.b7c807ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080820234615.258a9c04.akpm@linux-foundation.org>
	 <20080821.001322.236658980.davem@davemloft.net>
	 <20080821002757.b7c807ad.akpm@linux-foundation.org>
X-Google-Sender-Auth: f746a273651d08d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> IA64 seems to be one of the few platforms to define this as a macro
>> evaluating to the node-to-cpumask array entry, so it's clear what
>> platform Motohiro-san did build testing on :-)
>
> Seems to compile OK on x86_32, x86_64, ia64 and powerpc for some reason.
>
> This seems to fix things on sparc64:
>
> --- a/mm/quicklist.c~mm-quicklist-shouldnt-be-proportional-to-number-of-cpus-fix
> +++ a/mm/quicklist.c
> @@ -28,7 +28,7 @@ static unsigned long max_pages(unsigned
>        unsigned long node_free_pages, max;
>        int node = numa_node_id();
>        struct zone *zones = NODE_DATA(node)->node_zones;
> -       int num_cpus_per_node;
> +       cpumask_t node_cpumask;
>
>        node_free_pages =
>  #ifdef CONFIG_ZONE_DMA
> @@ -41,8 +41,8 @@ static unsigned long max_pages(unsigned
>
>        max = node_free_pages / FRACTION_OF_NODE_MEM;
>
> -       num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));
> -       max /= num_cpus_per_node;
> +       node_cpumask = node_to_cpumask(node);
> +       max /= cpus_weight_nr(node_cpumask);
>
>        return max(max, min_pages);
>  }

Thank you!!
