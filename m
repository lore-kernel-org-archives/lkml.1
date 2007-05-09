Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbXEIR4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbXEIR4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbXEIR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:56:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43861
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbXEIR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:56:35 -0400
Date: Wed, 9 May 2007 10:53:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509194845.1caf5fd0@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0705091050410.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
 <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
 <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
 <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
 <20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
 <20070509190736.35cf51d2@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705091007160.4467@asgard.lang.hm>
 <20070509194845.1caf5fd0@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Cornelia Huck wrote:

> On Wed, 9 May 2007 10:09:33 -0700 (PDT),
> david@lang.hm wrote:
>
>>> Hm, so that sound like a case for a distinct setup() routine:
>>>
>>> 1. bus calls ->probe(), which return synchronously
>>> 2. bus calls ->probe_async() for all devices (optional)
>>> 3. bus waits for all probes to finish
>>> 4. bus calls ->setup() for all devices (which does the registering)
>>
>> this is exactly what I've been trying to describe.
>
> Nearly, but with a slightly different spin...
>
>>
>>> (->setup() can but need not be sync, although it should be for your
>>> case)
>>
>> if it's not sync then you have race conditions again
>
> ...but not all busses will care. If your bus wants to enforce ordering,
> it must enforce it to be sync. If your bus allows hotplug and calling
> setup() later on, it may also allow async. (setup() is a bit
> dual-purpose in this idea.)

if you want the registration to use hotplug and be async then do do the 
registration during step 2 and make step 4 be a noop, in fact some drivers 
may do all their work in step 2, while others (everything currently) will 
do all their work during step 1

David Lang


