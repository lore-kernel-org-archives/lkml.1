Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYFZAR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYFZAR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYFZARV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:17:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYFZARU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:17:20 -0400
Message-ID: <4862D7FE.7070507@kernel.org>
Date: Wed, 25 Jun 2008 16:42:54 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
References: <patchbomb.1214367536@localhost>	<93c7057b1f4acae501b2.1214367539@localhost>	<20080624214441.13202f12@infradead.org>	<4862B3E9.50601@goop.org> <20080625153136.2b3b6737@infradead.org> <4862D247.2010709@kernel.org> <4862D6CC.7090205@goop.org>
In-Reply-To: <4862D6CC.7090205@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> Actually, I believe the barrier(); before is actually incorrect, since 
>> it would affect the wrmsr() register arguments rather than the wrmsr 
>> instruction itself.
> 
> How so?  What kind of failure do think might occur?  Some effect on how 
> the wrmsr arguments are evaluated?
> 
> barrier() is specifically a compiler optimisation barrier, so the 
> barrier before would prevent the compiler from moving anything logically 
> before the wrmsr to afterwards.
> 

The barrier() before prevents the compiler from optimizing the access to 
the arguments (before they go into registers), not the actual wrmsr; 
this has to do with the ordering of operations around the barrier above. 
  The barrier *after* does what you just describe.

> That said, making the wrmsr itself a memory clobber may be simpler 
> understand with a comment, rather than separate barriers...

This should be functionally equivalent to a barrier(); after, and given 
that this is clearly a point of confusion *already*, I think the memory 
clobber is better.

	-hpa
