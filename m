Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbZKZQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbZKZQZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZKZQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:25:43 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51637 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZKZQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:25:41 -0500
Message-ID: <4B0EAC06.3010407@linux.vnet.ibm.com>
Date: Thu, 26 Nov 2009 17:25:42 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
References: <4B0EA88E.3030205@linux.vnet.ibm.com> <1259252382.31676.207.camel@laptop>
In-Reply-To: <1259252382.31676.207.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 17:10 +0100, Christian Ehrhardt wrote:
>
>   
>> What I consider more important at the moment is that there is no hook to 
>> recalculate these values in case cpu hot add/remove takes place.
>> As an example someone could boot a machine with one online cpu and get 
>> the low non scaled defaults, later on driven by load the system 
>> activates more and more processors. Therefore the system could end up 
>> having  a large amount of cpus with non recalculated scheduler tunables.
>>     
>
> This is virt junk that's playing dumb games with hotplug isn't it?
>   
Some sort of, its on s390 which does that all the time. By default there 
is a daemon that activates/deactivates cpus according to load to cover 
load peaks but also save virtualization overhead.
> Normal machines simply don't change their numbers of cpus, if they
> hotplug its usually for things like suspend or actual replacement of a
> faulty piece of kit, in which case there's little point in adjusting
> things.
>
>   
What is still "normal" today, you cant get s390 without virt so I would 
consider it normal and a real use case for us :-)
> Aside from that, we probably should put an upper limit in place, as I
> guess large cpu count machines get silly large values
I agree to that, but in the code is already an upper limit of 
200.000.000 - well we might discuss if that is too low/high.


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

