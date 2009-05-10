Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZEJJWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZEJJWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 05:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZEJJV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 05:21:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45369 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZEJJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 05:21:57 -0400
X-IronPort-AV: E=Sophos;i="4.40,323,1238976000"; 
   d="scan'208";a="5188571"
User-Agent: Microsoft-Entourage/12.17.0.090302
Date: Sun, 10 May 2009 10:21:48 +0100
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Linux@zytor.com" <Linux@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <C62C5B3C.AB1A%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
Thread-Index: AcnQ1RsVsbaPt7aeQIGlps/deltZxwAe6Nkw
In-Reply-To: <4A05CD29.6050505@zytor.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 10 May 2009 09:21:57.0091 (UTC) FILETIME=[C3E4CB30:01C9D150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2009 19:36, "H. Peter Anvin" <hpa@zytor.com> wrote:

>> My suggestion is that Xen changes its PAT[1] from WT to WC. AFAIK only
>> suse's Linux port is currently using Xen's PAT support, and it does not
>> actually use the WT cache attribute. Then Xen's PAT[0-3] would match what
>> Linux expects, and Linux apparently does not risk using PAT[4-7] because of
>> processor errata so their values are irrelevant. Linux can check that it is
>> running on Xen with suitable PAT setup by reading MSR_IA32_CR_PAT and
>> checking PAT[0-3], and only enable PAT usage in case of a match.
> 
> There exists at least one processor erratum where the CPU will use
> PAT[4-7] when the user requested PAT[0-3].  For those CPUs, it is unsafe
> for *any* OS to have PAT[4-7] != PAT[0-3].

Would it be unreasonable for us to disable PAT on such processors?

An alternative would be to set up PAT according to a new elfnote in the dom0
kernel image, and then only expose the PAT feature flag to domU kernels that
have matching PAT configuration. No elfnote would mean use Xen's existing
PAT setup (or if that's very dangerous then disable PAT altogether, perhaps
dependent on CPU model/stepping?).

 -- Keir


