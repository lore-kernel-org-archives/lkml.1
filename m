Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbZD3SjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbZD3SjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbZD3SjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:39:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZD3SjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:39:00 -0400
Date: Thu, 30 Apr 2009 15:37:28 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
X-X-Sender: v4l@pedra.chehab.org
To: Andi Kleen <andi@firstfloor.org>
cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
In-Reply-To: <20090430124716.GW23223@one.firstfloor.org>
Message-ID: <alpine.LRH.2.00.0904301522100.12182@pedra.chehab.org>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab> <20090430124716.GW23223@one.firstfloor.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Andi Kleen wrote:

>> Kconfig, mce code delivers needed error info to edac which, in turn,
>> goes and decodes the error/does the mapping to DIMM blocks/supplies DRAM
>> error injection facility for testing purposes and similar things. That
>> way you have both and they don't overlap in functionality.
>
> You can do that, but it's redundant because mcelog can do this
> this already. I had some conversations with existing EDAC users
> recently and they seem to only care about the resulting output,
> so just querying from mcelog is fine.
> The only issue is that mcelog needs to get the DIMM data. In many
> cases it can do so from SMBIOS output, if not a suitable interface
> would need to be provided by the kernel.

>From what I've heard from the existing EDAC users, they have several 
concerns that mcelog could be viable replacement to their EDAC usage, due 
to performance issues, including the need of accessing SMBIOS in order to 
get such information.

Also, EDAC interface is already stablished, and, as pointed by Doug, it is 
very useful on cluster environments, where memory failures is a big issue 
and need to be solved as soon as possible.

EDAC solves this issue very well and works on a wider range of designs 
than mcelog. So, there's no reason to deprecate it or to reject patches 
adding EDAC interfaces to other chips.

On the other hand, mcelog is also useful on different scenarios. So, they 
are not competing technologies, but complementary ones.

So, assuming that both EDAC and mcelog are needed, the proper design for 
those chipsets where the memory controller is integrated with other log 
functions (like AMD64 and Nethalem) seem to build an unique kernel layer 
that retrieves the error logs from the harware and allows access to the 
same data via both mcelog and EDAC userspace API's.

Cheers,
Mauro
