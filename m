Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZFVHyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZFVHyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZFVHyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:54:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:12212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZFVHyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:54:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,267,1243839600"; 
   d="scan'208";a="424197383"
Message-ID: <4A3F38A6.80906@linux.intel.com>
Date: Mon, 22 Jun 2009 00:54:14 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Martin Mares <mj@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-arch@vger.kernel.org
Subject: Re: RFC: x86: cap iomem_resource to addressable physical memory
References: <4A2F0D45.2040602@linux.intel.com> <86802c440906111343g513a2ceau1e2bfdf14c295b2d@mail.gmail.com> <4A316D3C.7080403@linux.intel.com> <20090621064201.GD1656@ucw.cz> <4A3DE3F3.4000100@linux.intel.com> <20090621205534.GA4324@elf.ucw.cz>
In-Reply-To: <20090621205534.GA4324@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> Ok... and is there enough locking in there so that it is actually ok
> to change mask during hotplug? (Is it okay because it is single long
> and all the writers are somehow serialized by hotplug mechanism?)
> 									Pavel

Making it a locked reference probably would be a good idea (although I 
personally think it will never actually matter in practice).  Although 
on 32 bits (PAE) it can be more than one long, it doesn't matter because 
only the upper long can actually be modified.  It does, however, 
complicate the actual code somewhat... I'll look at it tomorrow.

	-hpa

