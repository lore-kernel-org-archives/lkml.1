Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYANSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYANSOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYANSOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:14:30 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48681 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYANSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:14:29 -0500
Date: Mon, 14 Jan 2008 19:14:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: travis@sgi.com
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] x86: Change NR_CPUS arrays in numa_64
In-Reply-To: <20080113183455.077460000@sgi.com>
Message-ID: <Pine.LNX.4.64.0801141913100.24893@fbirervta.pbzchgretzou.qr>
References: <20080113183453.973425000@sgi.com> <20080113183455.077460000@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13 2008 10:35, travis@sgi.com wrote:
>--- a/arch/x86/kernel/setup_64.c
>+++ b/arch/x86/kernel/setup_64.c
>@@ -372,8 +373,9 @@ void __init setup_arch(char **cmdline_p)
> 	io_delay_init();
> 
> #ifdef CONFIG_SMP
>-	/* setup to use the static apicid table during kernel startup */
>+	/* setup to use the early static init tables during kernel startup */
> 	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
>+	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
> #endif
> 
> #ifdef CONFIG_ACPI

Please do not add unnecessary casts.

>--- a/arch/x86/kernel/smpboot_64.c
>+++ b/arch/x86/kernel/smpboot_64.c
>@@ -559,8 +563,16 @@ __cpuinit void numa_add_cpu(int cpu)
> 
> void __cpuinit numa_set_node(int cpu, int node)
> {
>+	u16 *cpu_to_node_map = (u16 *)x86_cpu_to_node_map_early_ptr;
>+

^

> static inline int cpu_to_node(int cpu)
> {
>-	return cpu_to_node_map[cpu];
>+	u16 *cpu_to_node_map = (u16 *)x86_cpu_to_node_map_early_ptr;

^
