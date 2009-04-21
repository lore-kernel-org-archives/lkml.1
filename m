Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZDUSGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZDUSGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZDUSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:05:52 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48346 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753728AbZDUSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:05:51 -0400
X-BigFish: VPS-38(zz1432R98dR4015M1805M936fK9371Pzz1202hzzz32i6bh43j)
X-FB-SS: 13,
X-WSS-ID: 0KIGQ8X-01-OHY-01
Date: Tue, 21 Apr 2009 20:05:14 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090421180514.GB2763@alberich.amd.com>
References: <20090417100155.GE16198@alberich.amd.com> <20090417162115.GF8253@elte.hu> <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com> <20090420084747.GA7286@alberich.amd.com> <86802c440904201423y7d1290e5m5b0e2529f3a81fc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440904201423y7d1290e5m5b0e2529f3a81fc3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Apr 2009 18:05:25.0490 (UTC) FILETIME=[BEE8E520:01C9C2AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 02:23:47PM -0700, Yinghai Lu wrote:
> On Mon, Apr 20, 2009 at 1:47 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> > During initialization the struct device's numa_node is set to -1 and
> > later on the information is inherited from the parent numa_node.
> >
> parent numa_node could be -1 too.
> 
> in amd_bus.c
> int get_mp_bus_to_node(int busnum)
> {
>         int node = -1;
> 
>         if (busnum < 0 || busnum > (BUS_NR - 1))
>                 return node;
> 
>         node = mp_bus_to_node[busnum];
> 
>         /*
>          * let numa_node_id to decide it later in dma_alloc_pages
>          * if there is no ram on that node
>          */
>         if (node != -1 && !node_online(node))
>                 node = -1;
> 
>         return node;
> }

Ok, I see.
Thanks,

Andreas


