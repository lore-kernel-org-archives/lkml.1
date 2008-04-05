Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYDEQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYDEQC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 12:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYDEQCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 12:02:49 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:57521
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYDEQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 12:02:48 -0400
Message-ID: <47F7A190.9070401@qumranet.com>
Date: Sat, 05 Apr 2008 18:58:08 +0300
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
References: <20080309164050.2194461e@daedalus.pq.iki.fi>	 <20080328222500.21863a44@daedalus.pq.iki.fi>	 <20080330202608.054702a4@daedalus.pq.iki.fi>	 <20080404000701.70bbc1a4@daedalus.pq.iki.fi>	 <47F72C12.9020701@qumranet.com> <84144f020804050040r6fd8b9a8h6d344b4ea53cb3e5@mail.gmail.com> <47F772E9.4000902@qumranet.com>
In-Reply-To: <47F772E9.4000902@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Sat, 05 Apr 2008 18:58:09 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> For kmemcheck, I'd prefer the per-CPU page tables suggested by Ingo.
>> I'm having hard time understanding why that's a "ugly hack" compared
>> to using kvm for this...
>>   
>
> It's not an ugly hack, but will be very very difficult.  With mmu 
> notifiers it's probably doable though:
>
> - the linux page tables are never loaded into cr3, but rather kept as 
> a reference
> - page faults are by instantiating ptes into shadow page tables (which 
> track the linux page tables)
> - mmu notifiers are used to drop shadow ptes when the linux ptes change
>

Actually, paravirt_ops is a much better match, as it also provides hooks 
for setting cr3.  I think you can implement per-cpu pagetables using 
paravirt_ops without modifying core mm code at all.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

