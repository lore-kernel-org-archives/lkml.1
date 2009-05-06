Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZEFMrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZEFMrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZEFMqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:46:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36478 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbZEFMqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:46:54 -0400
Message-ID: <4A0184F7.7070309@redhat.com>
Date: Wed, 06 May 2009 15:39:19 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com>
In-Reply-To: <4A0181EA.3070600@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Izik Eidus wrote:
>> Rik van Riel wrote:
>>> Izik Eidus wrote:
>>>> subjects say it all.
>>>
>>> Not a very useful commit message.
>>>
>>> This makes me wonder, though.
>>>
>>> What happens if a user mmaps a 30MB memory region, registers it
>>> with KSM and then unmaps the middle 10MB?
>>
>> User cant break 30MB into smaller one.
>
> The user can break up the underlying VMAs though.

So? KSM work on contigiouns virtual address, if user will break its 
virtual address and will leave it to be registered inside ksm
get_user_pages() will just fail, and ksm will skip scanning this 
addresses...

Normal usage of ksm is:

1) Allocating big chunck of memory.

2) registering it inside ksm

3) free the memory and remove it from ksm...

>
> I am just wondering out loud if we really want two
> VMA-like objects in the kernel, the VMA itself and
> a separate KSM object, with different semantics. 
>
> Maybe this is fine, but I do think it's a question
> that needs to be thought about.


Yea, we had some talk about that issue, considering the fact that user 
register its memory using ioctl and not systemcall, and considering the 
fact that ksm is loadable module that the kernel doesnt depend on,

How would you prefer to see the interface?


