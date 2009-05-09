Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZEIIO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZEIIO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZEIIOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:14:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbZEIIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:13:56 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2009 04:13:56 EDT
X-IronPort-AV: E=Sophos;i="4.40,320,1238976000"; 
   d="scan'208";a="5182777"
User-Agent: Microsoft-Entourage/12.17.0.090302
Date: Sat, 09 May 2009 09:04:08 +0100
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, <Linux@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <C62AF788.AAE1%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
Thread-Index: AcnQbmzcsN7BkIN8SpipbDH09qFsgAADk2gS
In-Reply-To: <20090508155031.4403f7e0@lxorguk.ukuu.org.uk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 09 May 2009 08:04:11.0653 (UTC) FILETIME=[BCA9B350:01C9D07C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 15:50, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:

>> Roughly speaking the kernel needs to cope with different values written
>> to MSR_IA32_CR_PAT than the single hard coded value it would write
>> itself if given the chance. Essentially _PAGE_CACHE_* need to become
>> dynamic (or I guess we could change the native layout to match Xen's, I
>> don't know why native differs from the initial state, I guess just to
>> avoid using the PAT bit for some reason.
> 
> Because it is required for some processor variants due to errata. This is
> also why the BIOS has them programmed as a mirror between 0-3 and 4-7.
> 
> I don't think changing Linux here is the right thing to do - if anything
> Xen probably needs to change.

My suggestion is that Xen changes its PAT[1] from WT to WC. AFAIK only
suse's Linux port is currently using Xen's PAT support, and it does not
actually use the WT cache attribute. Then Xen's PAT[0-3] would match what
Linux expects, and Linux apparently does not risk using PAT[4-7] because of
processor errata so their values are irrelevant. Linux can check that it is
running on Xen with suitable PAT setup by reading MSR_IA32_CR_PAT and
checking PAT[0-3], and only enable PAT usage in case of a match.

 -- Keir


