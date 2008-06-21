Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYFUKvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYFUKvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYFUKux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:50:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:30137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYFUKuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=vG9USqaWgBKry4lluh+arlbnYWY+gadaL9UWZNBlQupm0Z7ubhTPtvs+7GTrljIL9a
         anRQRi7ZRCzwrrr6h/NpyB/CxQgZ9+BNdvAv9GudrThLM+9MgFxDNZbA6OJnwU5MoM2l
         a+it3KTpkBcF6Nrp3xyxr86ceh/EbXMmCWhLE=
Message-ID: <86802c440806210350y2f05999fme0eba7ca6aca201a@mail.gmail.com>
Date: Sat, 21 Jun 2008 03:50:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kevin Winchester" <kjwinchester@gmail.com>
Subject: Re: Bisecting tip/auto-x86-next?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <485CDA6A.103@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6144_26156524.1214045447983"
References: <485AFC9B.7090502@gmail.com>
	 <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com>
	 <20080620153626.GE17373@elte.hu> <485C4484.3080706@gmail.com>
	 <86802c440806201714p271b7b3fx68183c5f48208bee@mail.gmail.com>
	 <485CD12C.9080404@gmail.com>
	 <86802c440806210318p23fc61bo709c0965254de72@mail.gmail.com>
	 <d1af83620806210323j6b55db5ar61a45a4cd416a319@mail.gmail.com>
	 <86802c440806210330r25529b93u9c57734ad4fce58d@mail.gmail.com>
	 <485CDA6A.103@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6144_26156524.1214045447983
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jun 21, 2008 at 3:39 AM, Kevin Winchester
<kjwinchester@gmail.com> wrote:
> Yinghai Lu wrote:
>>
>> On Sat, Jun 21, 2008 at 3:23 AM, Kevin Winchester
>> <kjwinchester@gmail.com> wrote:
>>>
>>> On Sat, Jun 21, 2008 at 7:18 AM, Yinghai Lu <yhlu.kernel@gmail.com>
>>> wrote:
>>>>
>>>> On Sat, Jun 21, 2008 at 3:00 AM, Kevin Winchester
>>>> <kjwinchester@gmail.com> wrote:
>>>>>
>>>>> Yinghai Lu wrote:
>>>>>>
>>>>>> On Fri, Jun 20, 2008 at 5:00 PM, Kevin Winchester
>>>>>> <kjwinchester@gmail.com> wrote:
>>>>>>>
>>>>>>> Ingo Molnar wrote:
>>>>>>>>
>>>>>>>> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>>>>>>>>
>>>>>>>>>> hm, could you send me the config that triggered this?
>>>>>>>>>
>>>>>>>>> I will do so tonight when I am home again.  It is a UP AMD64 box
>>>>>>>>> with a
>>>>>>>>> VIA chipset, if that helps.
>>>>>>>>>
>>>>>>>>>> btw., you can probably ignore this one safely. Also please tell me
>>>>>>>>>> at
>>>>>>>>>> which commit ID you were at when you triggered this warning.
>>>>>>>>>
>>>>>>>>> Good to know - I will get the commit ID tonight as well, although
>>>>>>>>> wouldn't following the same bisection sequence that I did give you
>>>>>>>>> the
>>>>>>>>> same
>>>>>>>>> bisection point?  I guess that would assume that linus/master and
>>>>>>>>> auto-x86-next haven't changed much since last night, which might
>>>>>>>>> not be
>>>>>>>>> correct.
>>>>>>>>
>>>>>>>> yeah, you'd probably not hit that warning with the x86/gart
>>>>>>>> bisection
>>>>>>>> sequence. (Assuming the bug is introduced in that branch - so you
>>>>>>>> should
>>>>>>>> first check whether pure x86/gart kernel triggers the problem too.)
>>>>>>>>
>>>>>>>> If you still have the commit ID around then please send it - if you
>>>>>>>> dont,
>>>>>>>> no problem, it's no big issue. I wanted to check how wide the
>>>>>>>> bisection
>>>>>>>> window is where the warning triggers.
>>>>>>>>
>>>>>>> I'm sorry - I accidentally checkout out x86/gart to test it before
>>>>>>> grabbing
>>>>>>> the commit ID.
>>>>>>>
>>>>>>> I went ahead with the bisection and found:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> 8c9fd91a0dc503f085169d44f4360be025f75224 is first bad commit
>>>>>>> commit 8c9fd91a0dc503f085169d44f4360be025f75224
>>>>>>> Author: Yinghai Lu <yhlu.kernel@gmail.com>
>>>>>>> Date:   Sun Apr 13 18:42:31 2008 -0700
>>>>>>>
>>>>>>>  x86: checking aperture size order
>>>>>>>
>>>>>>>  some systems are using 32M for gart and agp when memory is less than
>>>>>>> 4G.
>>>>>>>  Kernel will reject and try to allcate another 64M that is not
>>>>>>> needed,
>>>>>>>  and we will waste 64M of perfectly good RAM.
>>>>>>>
>>>>>>>  this patch adds a workaround by checking aper_base/order between NB
>>>>>>> and
>>>>>>>  agp bridge. If they are the same, and memory size is less than 4G,
>>>>>>> it
>>>>>>>  will allow it.
>>>>>>>
>>>>>>>  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>>>>>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>>>>  Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>>>>>>
>>>>>>> :040000 040000 848d6e4045a14d01fc0a794d4350d8a84f3ceff6
>>>>>>> 4a10a52b41309060cd5dc1bf0c322f6d43b2477b M      arch
>>>>>>> :040000 040000 aa1cee87b1f5b1b30ed03ce6164ad7f404fef2a3
>>>>>>> f9ce0aaa1f7d4fdc7bdc5a43285495db53a6f531 M      drivers
>>>>>>>
>>>>>>>
>>>>>>> as the first bad commit.  I do not have time to look at the patch
>>>>>>> right
>>>>>>> now,
>>>>>>> but in case anyone else does, I figured I would post it.
>>>>>>>
>>>>>> please send out whole boot logs with "debug" in command line.
>>>>>>
>>>>> "debug" in the command line doesn't seem to have any effect on the
>>>>> printout
>>>>> (is there some config option I need to use with it?), but here it is
>>>>> anyway:
>>>>
>>>> are you using tip/master?
>>>>
>>>> http://people.redhat.com/mingo/sched-devel.git/README
>>>>
>>> That log is from tip/x86/gart, which is where the problem patch was
>>> bisected.  Would you get better debugging info from tip/master (which
>>> includes tip/x86/gart, I believe, and thus would show the problem as
>>> well)?
>>
>> tip/master doesn't work?
>>
>
> I will check tip/master now, but I believe it doesn't work.
>
> I will also correct myself, the log I sent you was from:
>
> 8c9fd91... x86: checking aperture size order
>

please try attached patch...

YH

------=_Part_6144_26156524.1214045447983
Content-Type: text/x-patch; name=gart_any_mapped.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhq3b90k0
Content-Disposition: attachment; filename=gart_any_mapped.patch

W1BBVENIXSB4ODY6IGNoYW5nZSBiYWNrIHRvIGFueV9tYXBwZWQKCmFncCBjaGVjayBpcyB1c2lu
ZyByZXF1ZXN0X21lbV9yZWdpb24uIGFuZCBjb3VsZCBmYWlsIGlmIGU4MjAgcmVzZXJ2ZWQuLi4K
ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvYXBlcnR1cmVfNjQuYyBiL2FyY2gveDg2L2tlcm5lbC9h
cGVydHVyZV82NC5jCmluZGV4IGU2ZGVlZDEuLjYwMDQ3MGQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2tlcm5lbC9hcGVydHVyZV82NC5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9hcGVydHVyZV82NC5j
CkBAIC0zMjQsOCArMzI0LDggQEAgdm9pZCBfX2luaXQgZWFybHlfZ2FydF9pb21tdV9jaGVjayh2
b2lkKQogCQlmaXggPSAxOwogCiAJaWYgKGdhcnRfZml4X2U4MjAgJiYgIWZpeCAmJiBhcGVyX2Vu
YWJsZWQpIHsKLQkJaWYgKCFlODIwX2FsbF9tYXBwZWQoYXBlcl9iYXNlLCBhcGVyX2Jhc2UgKyBh
cGVyX3NpemUsCi0JCQkJICAgIEU4MjBfUkVTRVJWRUQpKSB7CisJCWlmIChlODIwX2FueV9tYXBw
ZWQoYXBlcl9iYXNlLCBhcGVyX2Jhc2UgKyBhcGVyX3NpemUsCisJCQkJICAgIEU4MjBfUkFNKSkg
ewogCQkJLyogcmVzZXJ2ZSBpdCwgc28gd2UgY2FuIHJldXNlIGl0IGluIHNlY29uZCBrZXJuZWwg
Ki8KIAkJCXByaW50ayhLRVJOX0lORk8gInVwZGF0ZSBlODIwIGZvciBHQVJUXG4iKTsKIAkJCWU4
MjBfYWRkX3JlZ2lvbihhcGVyX2Jhc2UsIGFwZXJfc2l6ZSwgRTgyMF9SRVNFUlZFRCk7Cg==
------=_Part_6144_26156524.1214045447983--
