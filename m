Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbYDBWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbYDBWOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYDBWOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:14:05 -0400
Received: from gw.goop.org ([64.81.55.164]:54855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYDBWOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:14:03 -0400
Message-ID: <47F404F1.30103@goop.org>
Date: Wed, 02 Apr 2008 15:13:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org>	 <1206751622.27091.20.camel@nimitz.home.sr71.net>	 <47EDA4B9.6030801@goop.org>	 <1206806774.31896.27.camel@nimitz.home.sr71.net>	 <47EED683.5030200@goop.org>	 <1206981741.31896.51.camel@nimitz.home.sr71.net>	 <47F1282E.3020503@goop.org>	 <1207161962.23710.23.camel@nimitz.home.sr71.net>	 <47F3D5D9.1010301@goop.org>	 <1207162792.23710.28.camel@nimitz.home.sr71.net>	 <47F3F4A0.9010009@goop.org>	 <1207171050.23710.48.camel@nimitz.home.sr71.net>	 <47F3FC2E.7090806@goop.org> <1207172610.23710.55.camel@nimitz.home.sr71.net>
In-Reply-To: <1207172610.23710.55.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-04-02 at 14:35 -0700, Jeremy Fitzhardinge wrote:
>   
>> Dave Hansen wrote:
>>     
>>> Oh, once we've let Linux establish ptes to it, we've required that the
>>> hypervisor have it around?  How does that work with the balloon driver?
>>> Do we destroy the ptes when giving balloon memory back to the
>>> hypervisor?
>>>       
>> Yep.  It removes any mapping before handing it back to the hypervisor.
>>     
>
> Wow.  So does Xen ever use PSE to map kernel data?  That sucks.
>   

Not at present.  But I'd like to change it to manage memory in largepage 
chunks so that we can.

> Yeah, but I'm just talking about hotplugged memory.  When we add it, we
> don't have to map the added pages (since they're highmem) and don't have
> to touch their contents and zero them out, either.  Then, the balloon
> driver can notice that the memory is too large, and start to balloon it
> down.
>   

I didn't think x86-64 had a notion of highmem.

How do you prevent the pages from being used before they're ballooned out?

>> Everything also applies to x86-64.
>>     
>
> Not really, though.  We don't have the page->flags shortage or lack of
> vmemmap on x86_64.

Right now, I'd rather have a single mechanism that works for both.

    J
