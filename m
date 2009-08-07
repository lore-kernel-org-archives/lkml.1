Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZHGGNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZHGGNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZHGGNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:13:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51453 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbZHGGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:13:05 -0400
X-IronPort-AV: E=Sophos;i="4.43,339,1246831200"; 
   d="scan'208";a="30881083"
Message-ID: <4A7BC5FC.2070905@inria.fr>
Date: Fri, 07 Aug 2009 08:13:16 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       paulus@samba.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
References: <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr>
In-Reply-To: <4A7B68C3.7040706@inria.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> Ingo Molnar wrote:
>   
>> It would be nice to add this as some "perf report -s/--stats" flag, 
>> to not have to go via -D (which is a 'print debug output' kind of 
>> ad-hoc thing and subject to format changes in the future).
>>
>> Would you be interested in sending a patch that adds that flag to 
>> 'perf report', to print out these statistics entries (if any), in a 
>> tabular form suitable for your purposes? Below is a past patch to 
>> builtin-report.c that shows how to add new options.
>>   
>>     
>
> Here's a quick'n'dirty first try. Read events are copied in the
> show_stat_event array during process_read_event. And __cmd_report sorts
> the array by tid before displaying it.
>
> perf report -S now shows the following after the existing output: (-s is
> already used for something else).
> It shows things like
> # Per-thread statistics:
> # PID    TID       Event          Count
>   16709   16709   cache-misses   82727
>   16709   16709   cache-references   41238768
>   16709   16710   cache-misses   6462
>   16709   16710   cache-references   76119375
> or
> # Per-thread statistics:
> # PID    TID       Event          Count
>   6268   6268   raw 0x1000001e0   494628
>   6268   6268   raw 0x1000002e0   209113
>   6268   6268   raw 0x1000004e0   307215
>   6268   6268   raw 0x1000008e0   9203221
>   6268   6269   raw 0x1000001e0   9210788
>   6268   6269   raw 0x1000002e0   302344
>   6268   6269   raw 0x1000004e0   198705
>   6268   6269   raw 0x1000008e0   473471
>
> Obviously, there's some a lot of nice pretty printing to do, but you'll
> be able to tell whether the general idea is ok or not.
>   


Is there an easy way to know how many threads and how many different
event types were recorded? Once I know that, I could directly gather
values into a 2D matrix and display a single line per thread with all
corresponding event counter (so that people can easily apply awk to
manipulate them).

I am adding some pretty printing to the previous patch and waiting for
your feedback (for instance, what kind of global variable names, command
line option names, ... do you want or so).

Brice

PS: Is there a perf counters mailing list?
