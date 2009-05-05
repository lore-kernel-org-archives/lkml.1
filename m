Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZEESxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZEESxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZEESxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:53:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:37007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbZEESw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,298,1239001200"; 
   d="scan'208";a="409720262"
Date: Tue, 5 May 2009 11:52:48 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH 1/4] pci/x86: don't assume pref memio are 64bit -v4
Message-ID: <20090505115248.63d112f4@hobbes>
In-Reply-To: <49F13690.3080902@kernel.org>
References: <20090420223305.GA15340@jurassic.park.msu.ru>
	<49ED0EBC.4070901@kernel.org>
	<20090421105629.GB17904@jurassic.park.msu.ru>
	<49EF9C10.6090107@kernel.org>
	<20090422154900.08f8f366@hobbes>
	<49EFBB0E.3030401@kernel.org>
	<20090422180505.2518e837@hobbes>
	<49EFCE15.3030605@kernel.org>
	<20090423132202.GB13984@jurassic.park.msu.ru>
	<49F08580.9050407@kernel.org>
	<20090423221936.GA24171@jurassic.park.msu.ru>
	<49F13690.3080902@kernel.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 20:48:32 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> we should not assign 64bit range to pci device that only take 32bit
> pref
> 
> try to set IORESOURCE_MEM_64 in 64bit resource of
> pci_device/pci_bridge and make the bus resource only have that bit
> set when all device under that do support 64bit pref mem then use
> that flag to allocate resource in wanted area
> 
> v2: fix b_res->flags and logic and passing result.
> v3: split iomem to iomem32, iomem64, and iomem64 will take
> IORESOURCE_MEM_64 V4: according to Ivan
>     make it support x86 only, by PCIBIOS_MAX_MEM_32
>     double check if the bridge does support pref mem64 with
> write/read UPPER32
> 
> [Impact: do assign wrong range to device that doesn't support it]

Thanks a lot Yinghai & Ivan, I applied 1 & 2 (the other 2 e820 patches
should go through Ingo), they're in my linux-next branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
