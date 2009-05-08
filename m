Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZEHO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZEHO3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZEHO3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:29:01 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34013 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZEHO3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:29:01 -0400
X-BigFish: VPS-18(zzdf9M98dR4015L936fJzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJBXJX-02-65W-01
Date: Fri, 8 May 2009 16:28:25 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090508142825.GA9991@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090504173330.GF28728@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 May 2009 14:28:49.0604 (UTC) FILETIME=[4DC7D040:01C9CFE9]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 07:33:30PM +0200, Andreas Herrmann wrote:
> For all cores on the same multi-node CPU (Magny-Cours) /proc/cpuinfo
> will show:
> - same phys_proc_id
> - cpu_node_id of the internal node (0 or 1)
> - cpu_core_id (e.g. in range of 0 to 5)

Are there further objections (besides Andi's) to show cpu_node_id
in /proc/cpuinfo?

As I've written in another mail I also plan to introduce
cpu_node_siblings and expose this information in
/sys/devices/system/cpu/cpuX/topology

That would mean:
- for single-node processors node_siblings are equal to
  core_siblings.
- for dual-node processors node_siblings is the union of
  two sets of core_siblings (one set on each node).

Any objections/comments? Should I use some other naming instead of node?
Node means a set of cores plus a northbirdge and memory controller.
But maybe I should use chip instead of node (chip_siblings, cpu_chip_id,
etc.)? This would be in dependence on multi-CHIP module.

> Patches are against tip/master as of today.
> Please consider patches 1 and 2 for .30.

I guess it's way too late to add something like this for .30, right?
So I'll prepare some new patches and try to hit .31.


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


