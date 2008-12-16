Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYLPTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYLPTYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLPTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:24:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYLPTYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:24:14 -0500
Date: Tue, 16 Dec 2008 20:23:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Martin Steigerwald <ms@teamix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: physical memory limit of 64-bit linux
Message-ID: <20081216192354.GA843@elte.hu>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl> <20081216184742.GL11683@elte.hu> <4947FC68.4020603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947FC68.4020603@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> phase 3)  We could also go close to 47 bits: with various more invasive
>>           movings of VMALLOC and rest upwards, and other considerations
>>           such as the elimination of the generous start of 8 TB hole at
>>           __PAGE_OFFSET - i.e. moving __PAGE_OFFSET straight down to
>>           minus 128 TB. 120 TB would be doable.
>>   
>
> Originally it was there, but I moved it up because that's where Xen puts 
> itself when running a PV 64-bit guest.  It is also properly 
> parameterised now, so we could make it move on the basis of a config 
> setting.

[ i knew why i Cc:-ed you ;-) ]

>> phase 4)  If the 48 bits limit is ever lifted on the CPU side, we can move
>>           __PAGE_OFFSET down. This is actually less invasive than phase 
>>           3), because moving __PAGE_OFFSET is relatively easy. The far
>>           more invasive change would be the necessary changes to the
>>           virtual memory code: the current 4-level paging has a 256 TB  
>>           limit which comes from the 512*512*512*512*4K split of        
>>    pgd/pud/pmd/pte entries. Either PGDIR_SHIFT would have to be         
>>   increased, moving the root pgtable's size from 4K to 8K or more,      
>>      or another pgdir level would have to be introduced (which is       
>>     even more intrusive and much less likely to be implemented by hw
>>           makers).
>>   
>
> ...or we could just reintroduce highmem ;)

Only over my cold dead body ;-)

It would also be utterly impractical: it gives at most one or two more 
bits in practice before it starts breaking down seriously.

The thing that made highmem on 32-bit a necessity was the slow (and still 
ongoing) transition to the 64-bit world.

There's no such necessity at 48 bits - hw makers will just have to extend 
the pagetable bits in some suitable fashion, if they want to extend the 
number of the outgoing physical pins. There's no bitness migration hard 
barrier here.

[ I suspect other OSs are a lot less flexible about their x86-64 limits 
  than us. ]

[ And i hope i wont be around by the time we get close to the 64-bit limit
  ;-) If it ever happens (it is not sure it will) it will be seriously 
  unfunny. ]

	Ingo
