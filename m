Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZFEAdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZFEAdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZFEAdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:33:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:56946 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFEAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=krkvmKPlI6vbtgQpp2aDlS8P/Ax5kDRgv8RmnhJeNPWj41gVVuETxdZVZESCTdunAT
         MH6QF67a80fKXeLm0e42GktkFLhyqPWY9fUG+yQ/H8o/U/WKIg5O4Gp5MRQwZeX6LBSJ
         ZyL5HwWHOiISmcxNfM2idBF19d40siRHp0O84=
Message-ID: <4A2867C1.90408@gmail.com>
Date: Thu, 04 Jun 2009 18:33:05 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: Andi Kleen <andi@firstfloor.org>, Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090604174059.GB9823@prithivi.gnumonks.org> <873aaf4uvw.fsf@basil.nowhere.org> <200906041529.49997.lkml@morethan.org>
In-Reply-To: <200906041529.49997.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> On Thu June 4 2009, Andi Kleen wrote:
>> Harald Welte <HaraldWelte@viatech.com> writes:
>>> why would it matter on UP? as indicated, I'm not the expert here, but I thought
>>> memory ordering issues only arise in SMP systems [or possibly with regard to
>>> DMA, but as we already explored much earlier in this thread, drivers that access
>>> DMA buffers whil the hardware owns them are buggy and need to be fixed]
>> Sorry we didn't establish that. Accessing data structures that are
>> also accessed by DMA hardware is pretty common in fact and memory
>> ordering issues also come up regularly (e.g. all the infamous PCI
>> posting bugs)
>>
>> What we established is that the drivers don't use LOCK for it
>> (or at least we think that's very unlikely)
>>
> 
> It was a real headache in the pa-risc port - -
> Even went so far as to build some experimental kernels where all
> the spin-lock structures where in a separate loader section.
> 
> That was to avoid in-direct interference - I.E: Both DMA and
> the processor handling the locking **both** invalidating the
> same cache line at the same time (only one can win).
> 
> Things might get that deep with this processor/chip-set combination;
> but pa-risc has some very unusual hardware in some older models.

That sort of thing should be architecturally impossible on x86. In order 
for something to invalidate the cache line, it first has to own it 
(except maybe for some unusual cases like Memory Write and Invalidate 
where the writer promises to overwrite the entire cache line).
