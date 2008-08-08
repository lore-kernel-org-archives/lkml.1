Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYHHPHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYHHPHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYHHPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:07:28 -0400
Received: from mail.lang.hm ([64.81.33.126]:36519 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYHHPH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:07:27 -0400
Date: Fri, 8 Aug 2008 08:08:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andi Kleen <andi@firstfloor.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: why are namespaces required?
In-Reply-To: <87ej4z4uf1.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0808080803060.32620@asgard.lang.hm>
References: <alpine.DEB.1.10.0808071752210.892@asgard.lang.hm> <20080808013304.GA27778@martell.zuzino.mipt.ru> <87ej4z4uf1.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Andi Kleen wrote:

> Alexey Dobriyan <adobriyan@gmail.com> writes:
>>
>> And while we're at it, data from my usual config adding _NS options
>> one-by-one.
>>
>> 	$ size vmlinux-000 vmlinux-uts-ns vmlinux-ipc-ns vmlinux-user-ns vmlinux-pid-ns
>> 	   text    data     bss     dec     hex filename
>> 	2560804  217296  225280 3003380  2dd3f4 vmlinux-000
>> 	2560948  217296  225280 3003524  2dd484 vmlinux-uts-ns	(+144)
>> 	2561452  217296  225280 3004028  2dd67c vmlinux-ipc-ns	(+504)
>> 	2561805  217296  225280 3004381  2dd7dd vmlinux-user-ns	(+353)
>> 	2562819  217300  225280 3005399  2ddbd7 vmlinux-pid-ns	(+1018)
>>
>> What amazing .text savings we have here.
>
> Fully agreed. Probably a lot of these CONFIG options should be just dropped.
> They are quite user unfriendly with very little gain.
>
> It seems like there is unbounded growth in different name space options
> which also implies unbounded CONFIG growth. At least they should be all
> consolidated into a single CONFIG.

from a size point of view the namespace options may not have much impact, 
but what about performance? supporting namespaces requires additional 
checking each time something is accessed (not to mention new codepaths).

how about consolodating all the namespace items under a single namespace 
menu item so that they can all be disabled with one click, but people who 
want fine-grained control over the different portions can still have it.

but (going back to my initial post) namespaces should not be forced on for 
!embeded (or if they are then the options to disable namespaces should be 
moved inside the embeded menu)

David Lang
