Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZLBRfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZLBRfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZLBRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:35:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50435 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZLBRfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:35:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TcHsuSWCbHu61qvosR6n5BBoG6t57PxYyjplJ5bdLeuRVy9cSaLCuLMSwjiSsLt2Ka
         cOqHQs4NCbBYa5Qv9j07SrT9COSLOs5Q1T0rqXV4rR0wvbwHV5/m5NXJwu8m2Mxz5oyc
         rxZHWi59afUy1Kxuzwmaqn/RDIT5wlx6IF99A=
MIME-Version: 1.0
In-Reply-To: <43e72e890911302354i1b17265ckb3aa81171a24174b@mail.gmail.com>
References: <4ADE2F66.1070703@gmail.com> <43e72e890911161515q64ff527cyefd7d769f3c501b@mail.gmail.com> 
	<a44ae5cd0911161641n36d3c746pb69a9cac1eba1784@mail.gmail.com> 
	<43e72e890911161708o607da2a5hefe98e92fd13ee7a@mail.gmail.com> 
	<43e72e890911191519h73bd6699if860257c049ba1a0@mail.gmail.com> 
	<43e72e890911231347k48f105dcw24dd99c1c39f034@mail.gmail.com> 
	<43e72e890911302354i1b17265ckb3aa81171a24174b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Dec 2009 09:34:55 -0800
Message-ID: <43e72e890912020934s35df08dfp28520e32b9bea2b2@mail.gmail.com>
Subject: Re: 2.6.32-rc5-git1 -- BUG kmalloc-8192: Poison overwritten (ath9k 
	implicated)
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 11:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Nov 23, 2009 at 1:47 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Nov 19, 2009 at 3:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Mon, Nov 16, 2009 at 5:08 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>> On Mon, Nov 16, 2009 at 4:41 PM, Miles Lane <miles.lane@gmail.com> wrote:
>>>>> On Mon, Nov 16, 2009 at 6:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>>> On Tue, Oct 20, 2009 at 1:45 PM, Miles Lane <miles.lane@gmail.com> wrote:
>>>>>>> Let me know if you want my .config file.  I think this was triggered by
>>>>>>> suspending my laptop.
>>>>>>>
>>>>>>> BUG kmalloc-8192: Poison overwritten
>>>>>>
>>>>>> Thanks for your report Miles.
>>>>>>
>>>>>> Are you using Linus' tree? Felix wrote some patches that got rid of
>>>>>> the rate control private area which we kmalloc/kfree and at least one
>>>>>> user reported that these patches fixed a memory leak. I'm curious if
>>>>>> the same patches would resolve this issue.
>>>>>>
>>>>>> Only thing is these patches apply against wireless-testing and not
>>>>>> 2.6.32. To test them you'd have to pull wireless-testing master to
>>>>>> your tree and then apply the patches both before and after.
>>>>>>
>>>>>> Would you be up to try that?
>>>>>
>>>>> Yes, definitely.  Thanks.  I will try to accomplish this and let you
>>>>> know if I get stuck.
>>>>
>>>> OK, not sure if a merge of wireless-testing will be clean so you may
>>>> want to just clone fresh.. Anyway after you get wireless-testing bits
>>>> you'll want to apply these:
>>>>
>>>> http://patchwork.kernel.org/patch/60127/
>>>> http://patchwork.kernel.org/patch/60128/
>>>> http://patchwork.kernel.org/patch/60126/
>>>>
>>>> If you want to merge wireless-testing you can try:
>>>>
>>>> git merge git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>>>> master
>>>>
>>>> If that'd doesn't gos smooth just clone it and I think you should be
>>>> able to safely --reference your current tree for objects for Linus'
>>>> tree.
>>>
>>> Miles I see no reply from you yet so I backported the patches in
>>> question for you. Can you please try 2.6.32-rc7 and apply these
>>> patches on top:
>>>
>>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/70-mac80211-total-ampdu-tx-info.patch
>>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/71-ath9k-remove-tx_info_priv.patch
>>
>> Miles, any luck testing this?
>
> Miles -- poke. The patches provided should apply on Linus' tree,
> please let us know if they fix the issue you reported.

Miles -- have you had a chance to test these backported patches?

  Luis
