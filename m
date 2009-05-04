Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZEDRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZEDRpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZEDRpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:45:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6140 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZEDRpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:45:31 -0400
X-BigFish: VPS-18(zz1432R98dR1805M936fJzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJ4RZD-02-PHY-01
Date: Mon, 4 May 2009 19:44:58 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090504174458.GJ28728@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090504173330.GF28728@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 May 2009 17:45:20.0158 (UTC) FILETIME=[17D893E0:01C9CCE0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 07:33:30PM +0200, Andreas Herrmann wrote:
> Hi,
> 
> Following patches add support for AMD Magny-Cours CPU.
> 
> I slightly change struct cpuinfo where I'd like to introduce
> cpu_node_id to reflect CPU topology for AMD Magny-Cours CPU which
> consists of two internal-nodes.
> 
> For all cores on the same multi-node CPU (Magny-Cours) /proc/cpuinfo
> will show:
> - same phys_proc_id
> - cpu_node_id of the internal node (0 or 1)
> - cpu_core_id (e.g. in range of 0 to 5)
> 
> I also change identification of core siblings (and thread siblings)
> which will also be based on cpu_node_id in addition to phys_proc_id.
> 
> Furthermore I adapt the L3 cache information to reflect the cache
> characteristics of one internal node instead of the entire package.
> 
> Primarily this changes are needed to correct core sibling information
> for Magny-Cours. This CPU has two NBs on one physical package -- each
> internal node has its own processor configuration space (i.e. set of
> northbridge PCI functions).

I should have mentioned that first two patches fix topology information
provided in /sys/devices/cpu/cpuX/topology (core_sibling information).

I think, the internal node information should also be exposed
there. E.g. introducing cpu_node_siblings and cpu_node_sibling_list.

But that affects other architectures (the code in
drivers/base/topology is not x86-specific) and probably needs some
more discussion. Patches to address this will follow.



Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


