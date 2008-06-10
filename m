Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYFJSFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYFJSFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYFJSFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:05:36 -0400
Received: from smtp28.orange.fr ([80.12.242.99]:44498 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYFJSFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:05:35 -0400
X-ME-UUID: 20080610180533355.56E23800008A@mwinf2802.orange.fr
Message-ID: <484EC25E.4070209@cosmosbay.com>
Date: Tue, 10 Jun 2008 20:05:18 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Mike Travis <travis@sgi.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com> <4846AD84.2090800@sgi.com> <Pine.LNX.4.64.0806101032550.17131@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806101032550.17131@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Wed, 4 Jun 2008, Mike Travis wrote:
> 
>> I'm a bit confused.  Why is DEFINE_PER_CPU_SHARED_ALIGNED() conditioned on
>> ifdef MODULE?
>>
>>         #ifdef MODULE
>>         #define SHARED_ALIGNED_SECTION ".data.percpu"
>>         #else
>>         #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
>>         #endif
>>
>>         #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)                       \
>>                 __attribute__((__section__(SHARED_ALIGNED_SECTION)))            \
>>                 PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name             \
>>                 ____cacheline_aligned_in_smp
> 
> Looks wrong to me. There can be shared objects even without modules.
> 
> 

Well, MODULE is not CONFIG_MODULES :)

If compiling an object that is going to be statically linked to kernel, 
MODULE is not defined, so we have shared objects.

When compiling a module, we cannot *yet* use .data.percpu.shared_aligned 
section, since module loader wont handle this section.

Alternative is to change modules linking for all arches to merge 
.data.percpu{*} subsections correctly, or tell module loader to take 
into account all .data.percpu sections.

AFAIK no module uses DEFINE_PER_CPU_SHARED_ALIGNED() yet...



