Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZD2WDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZD2WDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZD2WDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:03:40 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:41997 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZD2WDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:03:39 -0400
Message-ID: <49F8CEA3.1050301@oracle.com>
Date: Wed, 29 Apr 2009 15:03:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rostedt@goodmis.org, fweisbec@gmail.com,
       mathieu.desnoyers@polymtl.ca, wcohen@redhat.com
Subject: Re: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro
References: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com> <49F8A7D1.6010307@oracle.com> <20090429203439.GD21421@elte.hu>
In-Reply-To: <20090429203439.GD21421@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49F8CE56.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Jason Baron wrote:
>>> Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
>>> macro definitions. Paves the way for tracepoint docbook.
>>>
>>>
>>> Signed-off-by: Jason Baron <jbaron@redhat.com>
>>>
>>> ---
>>>  scripts/kernel-doc |   21 +++++++++++++++++++++
>>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
>>> index 0f11870..9d9ab4b 100755
>>> --- a/scripts/kernel-doc
>>> +++ b/scripts/kernel-doc
>>> @@ -1827,6 +1827,24 @@ sub reset_state {
>>>      $state = 0;
>>>  }
>>>  
>>> +sub tracepoint_munge() {
>>> +	my $tracepointname = 0;
>>> +	my $tracepointargs = 0;
>>> +
>>> +	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
>>> +		$tracepointname = $1;
>>> +	}
>>> +	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
>>> +		$tracepointargs = $1;
>>> +	}
>>> +	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
>>> +		print STDERR "Warning: Unrecognized tracepoint format: \n" .
>>> +			     "$prototype\n"
>> I'd prefer for this warning to use the usual kernel-doc warning format, with
>> file:line information:
>>
>> 		print STDERR "Warning(${file}:$.): Unrecognized ....
> 
> Good point - i'll wait for v2. Or would you like to carry them in 
> your kernel-doc tree?
> 
> This bit:
> 
>  include/trace/events/irq.h            |   46 ++++++++++++++++++++++++++++++---
> 
> Has changed in the tracing tree so it's probably better to carry it 
> there - once your review feedback has been addressed and once your 
> Acked-by is propagated into the patches.

Yes, that's fine with me.  Thanks.

-- 
~Randy
