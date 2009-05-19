Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZESPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZESPNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZESPNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZESPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:13:38 -0400
Message-ID: <4A12CC81.30108@kernel.org>
Date: Tue, 19 May 2009 08:13:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 - UV fix for memory-only blades
References: <20090515194508.GA8305@sgi.com>
In-Reply-To: <20090515194508.GA8305@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner wrote:
> Fix an endcase in handling UV blades that have memory
> but no cpus. The calculation of the highest blade number
> failed to handle these blades if they appear last in the
> configuration.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 12:00:59.000000000 -0500
> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 14:38:16.000000000 -0500
> @@ -632,6 +632,7 @@ void __init uv_system_init(void)
>  		pnode = (paddr >> m_val) & pnode_mask;
>  		blade = boot_pnode_to_blade(pnode);
>  		uv_node_to_blade[nid] = blade;
> +		max_pnode = max(pnode, max_pnode);
>  	}
>  
>  	map_gru_high(max_pnode);

node_possible_map should already include nodes with memory and without memory already.

maybe you could skip max_pnode calculating in the loop.

YH
