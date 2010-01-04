Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487Ab0ADFOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab0ADFOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824Ab0ADFOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:14:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38807 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0ADFOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:14:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B417972.7000200@np.css.fujitsu.com>
Date: Mon, 04 Jan 2010 14:15:30 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David John <davidjon@xenontk.org>
CC: jbarnes@virtuousgeek.org, rusty@rustcorp.com.au, andreas.herrmann3@amd.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Check the node argument passed to cpumask_of_node
References: <201001012255.28094.rjw@sisk.pl> <1262412947-3890-1-BlackWidow-davidjon@xenontk.org>
In-Reply-To: <1262412947-3890-1-BlackWidow-davidjon@xenontk.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

This problem also happened when the CONFIG_DEBUG_PER_CPU_MAPS was used,
so how about modifying the code for it working well?

Best Regards,
Jin Dongming

David John wrote:
> Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus' NUMA information"
> causes an null pointer dereference when reading from the sysfs attributes local_cpu*
> on Intel machines with no ACPI NUMA proximity info, since dev->numa_node gets set to -1
> for all PCI devices, which then gets passed to cpumask_of_node.
> 
> Ensure that the node value is valid.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> 
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index c5087d7..1141a6e 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -99,7 +99,8 @@ extern const struct cpumask *cpumask_of_node(int node);
>  /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
>  static inline const struct cpumask *cpumask_of_node(int node)
>  {
> -	return node_to_cpumask_map[node];
> +	return (node < 0 || node >= nr_node_ids) ? cpu_online_mask :
> +						   node_to_cpumask_map[node];
>  }
>  #endif
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


