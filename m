Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYCaQme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYCaQme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYCaQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:42:27 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1996 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751671AbYCaQm0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:42:26 -0400
Message-ID: <47F11443.7050302@tungstengraphics.com>
Date: Mon, 31 Mar 2008 18:41:39 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com>
In-Reply-To: <47F10C62.7040500@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>
>> Let me rehprase. Not really time-critical but it is of some 
>> importance that CPA is done quickly.
>> We're dealing with the tradeoff of reading from uncached device memory 
>
> uncached or write combining ?
The user-space mappings (the ones that we really use) are usually 
write-combined, whereas the kernel mappings are uncached. (I think this 
is OK since both mapping types implies no cache coherency). Even if 
(IIRC) write combining is theoretically prefetchable, some devices give 
read speeds around 9MB/s.
>
>> vs taking the pages out of
>> AGP, setting up a cache-coherent mapping, read and then change back. 
>> What we'd really would like to set up is a pool of completely 
>> unmapped (like highmem) pages. Then we could, to a large extent, 
>> avoid the CPA calls.
>
> changing attributes by nature means a tlb flush and a bunch of 
> expensive cache work.
> That's never going to be cheap, I guess it all depends on how much 
> work you do
> on the memory for it to pay off or not...
Indeed. Actually with the new non-wbinvd() CPA, We seem to benefit 
already if the buffer is a single page, though it's probably hard to 
measure the impact of repopulating the tlb.

/Thomas



