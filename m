Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbYAaN1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbYAaN1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYAaN1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:27:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:60633 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbYAaN1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:27:43 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
Date: Thu, 31 Jan 2008 14:27:38 +0100
User-Agent: KMail/1.9.6
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <1201764967.12950.25.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de> <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com>
In-Reply-To: <851fc09e0801310522s2d690c3ejef661e5ce6847f73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311427.38198.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> addr = ioremap(phys_addr, len);
> set_memory_x(addr);
> if (phys_addr < (end_pfn_mapped >> PAGE_SHIFT))
>         set_memory_x(__va(phys_addr));

If you just need the ioremap executable there is no reason to split 
up the direct mapping for this too. The x86 architecture does not require
x bits to be coherent between mappings; only the caching attributes.

-Andi

