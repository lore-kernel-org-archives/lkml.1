Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYJ2JZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYJ2JZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYJ2JZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:25:08 -0400
Received: from gw.goop.org ([64.81.55.164]:49812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYJ2JZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:25:07 -0400
Message-ID: <49082BBC.60302@goop.org>
Date: Wed, 29 Oct 2008 20:24:12 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with	BIOVEC_PHYS_MERGEABLE
References: <20081027094111.GU22217@kernel.dk> <4905A961.9000603@goop.org> <20081027115659.GZ22217@kernel.dk> <20081029080603J.fujita.tomonori@lab.ntt.co.jp> <20081029083713.GE6364@elte.hu>
In-Reply-To: <20081029083713.GE6364@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>   
>> On Mon, 27 Oct 2008 12:57:00 +0100
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>     
>>> On Mon, Oct 27 2008, Jeremy Fitzhardinge wrote:
>>>       
>>>> Jens Axboe wrote:
>>>>         
>>>>> Pretty much baffles me as well, xen should just need to do
>>>>>
>>>>> #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0
>>>>>  
>>>>>           
>>>> It needs to be a runtime switch, since we only want to do this when 
>>>> actually running under Xen.  Also, its possible that the two pages might 
>>>> actually be physically contiguous, so they could be merged anyway.
>>>>         
>>> Alright, then add a xen_biovec_phys_mergeable(vec1, vec2) in the xen
>>> code that actually checks this for real. You can add your switch there
>>> as well. Then put the BIOVEC_PHYS_MERGEABLE() in the xen arch includes,
>>> done.
>>>
>>> What Tomo is saying is that this has nothing to do with virtual merging,
>>> and he's right.
>>>       
>> Yeah, overriding BIOVEC_PHYS_MERGEABLE perfectly works for Xen. And it
>> is not related with BIO_VMERGE_BOUNDARY at all.
>>
>> Ingo, please put this patch into your tree:
>>
>> http://marc.info/?l=linux-kernel&m=122482703716620&w=2
>>     
>
> does it have any dependency on:
>
>   Subject: [PATCH 1/2] bio: define __BIOVEC_PHYS_MERGEABLE
>   

No, they're independent.  Defining __BIOVEC_PHYS_MERGEABLE will be 
useful for the Xen changes I need to make in the wake of Tomo's patch.

    J
