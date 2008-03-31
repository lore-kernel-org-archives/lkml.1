Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYCaJHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYCaJHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYCaJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:07:00 -0400
Received: from relay.gothnet.se ([82.193.160.251]:8950 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753589AbYCaJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:07:00 -0400
Message-ID: <47F0A988.7010707@tungstengraphics.com>
Date: Mon, 31 Mar 2008 11:06:16 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org>
In-Reply-To: <20080331083816.GC29105@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Also I think we need to clarify the semantics of the c_p_a 
>> functionality. Right now both AGP and DRM relies on c_p_a  doing an 
>> explicit cache flush. Otherwise the data won't appear on the device side 
>> of the aperture.
>>     
>
> But surely not in cpa I hope ? Or are you saying you first write data
> and then do cpa? If true that would be quite an abuse of CPA 
> I would say and you should fix it ASAP.
>
>   
As AGP buffers are moved in- and out of AGP, the caching policy changes, 
so yes, there may be writes to cache coherent memory that needs to be 
flushed at some point. Since CPA has been doing that up to now, and the 
codepaths involved are quite time-critical, a double cache-flush is a 
no-no, so if this is left to the caller, we must be able to tell CPA 
that any needed cache-flush has already been performed.
>> If we use self-snoop, the AGP and DRM drivers can't rely on this flush 
>> being performed, and they have to do the flush themselves, and for 
>>     
>
> They definitely should flush themselves if they want data to reach
> the device. That is obviously required any time they reuse a page
> too.
>   
Understood,
but then we *must* really find a way to say "don't flush the cache 
again", perhaps part of Dave's array function?

/Thomas
> -Andi
>   



