Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbYDEMjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbYDEMjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 08:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYDEMjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 08:39:35 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:50326
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYDEMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 08:39:34 -0400
Message-ID: <47F772E9.4000902@qumranet.com>
Date: Sat, 05 Apr 2008 15:39:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, vegard.nossum@gmail.com
Subject: Re: mmiotrace bug: recursive probe hit
References: <20080309164050.2194461e@daedalus.pq.iki.fi>	 <20080328222500.21863a44@daedalus.pq.iki.fi>	 <20080330202608.054702a4@daedalus.pq.iki.fi>	 <20080404000701.70bbc1a4@daedalus.pq.iki.fi>	 <47F72C12.9020701@qumranet.com> <84144f020804050040r6fd8b9a8h6d344b4ea53cb3e5@mail.gmail.com>
In-Reply-To: <84144f020804050040r6fd8b9a8h6d344b4ea53cb3e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Sat, Apr 5, 2008 at 10:36 AM, Avi Kivity <avi@qumranet.com> wrote:
>   
>> It should not be too difficult to modify x86_emulate.c to do everything
>> through a function vector.  However there is a simpler (for you) solution:
>> run the driver-to-be-reverse-engineered in a kvm guest, and modify kvm
>> userspace to log accesses to mmio regions.  This requires the not-yet-merged
>> pci passthrough support.  You can reverse engineer Windows drivers with this
>> as well.
>>
>>  This won't work for kmemcheck smp though.
>>     
>
> For kmemcheck, I'd prefer the per-CPU page tables suggested by Ingo.
> I'm having hard time understanding why that's a "ugly hack" compared
> to using kvm for this...
>   

It's not an ugly hack, but will be very very difficult.  With mmu 
notifiers it's probably doable though:

- the linux page tables are never loaded into cr3, but rather kept as a 
reference
- page faults are by instantiating ptes into shadow page tables (which 
track the linux page tables)
- mmu notifiers are used to drop shadow ptes when the linux ptes change

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

