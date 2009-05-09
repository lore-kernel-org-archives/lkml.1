Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZEISl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZEISl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZEISlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 14:41:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZEISlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 14:41:19 -0400
Message-ID: <4A05CD29.6050505@zytor.com>
Date: Sat, 09 May 2009 11:36:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keir Fraser <keir.fraser@eu.citrix.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Linux@zytor.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
References: <C62AF788.AAE1%keir.fraser@eu.citrix.com>
In-Reply-To: <C62AF788.AAE1%keir.fraser@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> 
> My suggestion is that Xen changes its PAT[1] from WT to WC. AFAIK only
> suse's Linux port is currently using Xen's PAT support, and it does not
> actually use the WT cache attribute. Then Xen's PAT[0-3] would match what
> Linux expects, and Linux apparently does not risk using PAT[4-7] because of
> processor errata so their values are irrelevant. Linux can check that it is
> running on Xen with suitable PAT setup by reading MSR_IA32_CR_PAT and
> checking PAT[0-3], and only enable PAT usage in case of a match.
> 

There exists at least one processor erratum where the CPU will use
PAT[4-7] when the user requested PAT[0-3].  For those CPUs, it is unsafe
for *any* OS to have PAT[4-7] != PAT[0-3].

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

