Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZL2Us4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZL2Us4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZL2Usz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:48:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZL2Usz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:48:55 -0500
Message-ID: <4B3A6BA5.60103@gmail.com>
Date: Tue, 29 Dec 2009 21:50:45 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 	2.6.32-git-053fe57ac
 v2
References: <cover.1260663000.git.re.emese@gmail.com>  <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com> <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com> <4B355AEF.3060508@gmail.com> <alpine.DEB.2.00.0912281244400.12772@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0912281244400.12772@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Sat, 26 Dec 2009, Emese Revfy wrote:
> 
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index 4996fc7..fb63aca 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
>>>>        return 0;
>>>>  }
>>>>
>>>> -static struct kset_uevent_ops slab_uevent_ops = {
>>>> +static const struct kset_uevent_ops slab_uevent_ops = {
>>>>        .filter = uevent_filter,
>>>>  };
>>>   CC      mm/slub.o
>>> mm/slub.c: In function 'slab_sysfs_init':
>>> mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
>>> discards qualifiers from pointer target type
>>> include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
>>> but argument is of type 'const struct kset_uevent_ops *'
>>>
>>> Hmm?
>>>
>> I double checked both the declaration and definitions of the affected
>> function/structure and they are consistently const here.
>> Can you tell me what patch/tree combination you encountered this warning with?
>> Thanks, Emese
>>
> 
> The warning emitted by gcc is pretty explicit; the second formal of 
> kset_create_and_add() takes a 'struct kset_uevent_ops *' type while you're 
> now passing 'const struct kset_uevent_ops *' as the result of your change.  
> That said, kset_create() could probably be modified with the const 
> qualifier, but that's outside the scope of your patchset and would have to 
> be proposed seperately.

I see what you mean, this was part of [PATCH 1/4] that I forgot to CC to you.
Emese

