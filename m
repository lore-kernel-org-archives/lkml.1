Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbZDXNQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbZDXNQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZDXNQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:16:45 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:36509 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZDXNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:16:44 -0400
Date: Fri, 24 Apr 2009 17:16:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH 1/4] pci/x86: don't assume pref memio are 64bit -v4
Message-ID: <20090424131641.GA31445@jurassic.park.msu.ru>
References: <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F13690.3080902@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:48:32PM -0700, Yinghai Lu wrote:
> 
> we should not assign 64bit range to pci device that only take 32bit pref
> 
> try to set IORESOURCE_MEM_64 in 64bit resource of pci_device/pci_bridge
> and make the bus resource only have that bit set when all device under that do support
> 64bit pref mem then use that flag to allocate resource in wanted area
> 
> v2: fix b_res->flags and logic and passing result.
> v3: split iomem to iomem32, iomem64, and iomem64 will take IORESOURCE_MEM_64
> V4: according to Ivan
>     make it support x86 only, by PCIBIOS_MAX_MEM_32
>     double check if the bridge does support pref mem64 with write/read UPPER32

Thanks, Yinghai.

> [Impact: do assign wrong range to device that doesn't support it]
> 
> Reported-by: Yannick <yannick.roehlly@free.fr>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
