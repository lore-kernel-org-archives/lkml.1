Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYDAWie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYDAWie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYDAWi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:38:26 -0400
Received: from mga07.intel.com ([143.182.124.22]:10553 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbYDAWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:38:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,589,1199692800"; 
   d="scan'208";a="226138767"
Message-ID: <47F2B788.1030101@linux.intel.com>
Date: Tue, 01 Apr 2008 15:30:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com> <47F2A948.5070108@tungstengraphics.com>
In-Reply-To: <47F2A948.5070108@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Arjan van de Ven wrote:
>> Thomas Hellström wrote:
>>> Given this problem, the previously mentioned use-case, and the fact 
>>> that we mostly really use user-space mappings,
>>> Is there a possibility we could add the following functions to Dave's 
>>> patch (provided they would work as intended, of course, namely 
>>> invalidate / bring back the kernel mapping).
>>
>> sadly there are multiple mappings, both in theory and practice.
>> Especially the _np / _p functions specifically work on only the 
>> mapping you specify.
>>
>> For this to work we would need to somehow make a "mark all mappings 
>> NP, but please only do the kernel ones" kind of thing.
>> The semantics of that are... lets say messy at best.
> Hmm, I'm not sure I follow you here. Are you saying that it's illegal to 
> have an NP mapping of a page (which, If I understand it correctly, means 
> no mapping at all) at the same time as you have a, say user-space WC 
> mapping pointing to the same physical page?

no.
What I'm saying is that even if you make one mapping NP, it's hard to know you got all of them,
even just the kernel one.

> 
> I was under the impression that calling CPA on the kernel mapping of 
> that page would do the rest?

this is not a correct assumption in general, especially not for things like
"present".
If a page is mapped 3 times in the kernel, and you set one to "np", the others
WILL stay mapped.

(and CPA itself no longer exists period ;)
