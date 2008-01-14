Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYANSKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYANSKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYANSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:10:34 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40783 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYANSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:10:33 -0500
Date: Mon, 14 Jan 2008 19:10:32 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: travis@sgi.com
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] x86: Change size of APICIDs from u8 to u16
In-Reply-To: <20080113183454.155968000@sgi.com>
Message-ID: <Pine.LNX.4.64.0801141908370.24893@fbirervta.pbzchgretzou.qr>
References: <20080113183453.973425000@sgi.com> <20080113183454.155968000@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13 2008 10:34, travis@sgi.com wrote:
>--- a/arch/x86/kernel/mpparse_64.c
>+++ b/arch/x86/kernel/mpparse_64.c
>@@ -132,7 +132,7 @@ static void __cpuinit MP_processor_info(
> 	 * area is created.
> 	 */
> 	if (x86_cpu_to_apicid_ptr) {
>-		u8 *x86_cpu_to_apicid = (u8 *)x86_cpu_to_apicid_ptr;
>+		u16 *x86_cpu_to_apicid = (u16 *)x86_cpu_to_apicid_ptr;
> 		x86_cpu_to_apicid[cpu] = m->mpc_apicid;
> 	} else {
> 		per_cpu(x86_cpu_to_apicid, cpu) = m->mpc_apicid;

You can do away with the cast while modifying this line.

>--- a/arch/x86/mm/srat_64.c
>+++ b/arch/x86/mm/srat_64.c
>@@ -384,6 +388,12 @@ int __init acpi_scan_nodes(unsigned long
> }
> 
> #ifdef CONFIG_NUMA_EMU
>+static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
>+	[0 ... MAX_NUMNODES-1] = PXM_INVAL
>+};
>+static unsigned char fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
>+	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
>+};
> static int __init find_node_by_addr(unsigned long addr)
> {
> 	int ret = NUMA_NO_NODE;

No u8/u16 here?
