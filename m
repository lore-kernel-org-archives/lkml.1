Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXLWNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXLWNzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXLWNzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:55:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40483 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLWNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:55:23 -0500
Message-ID: <476E68C7.6090901@linux.vnet.ibm.com>
Date: Sun, 23 Dec 2007 19:25:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Memory controller remove control_type feature
References: <20071220185358.3248.25416.sendpatchset@balbir-laptop> <20071221225941.98b7362d.akpm@linux-foundation.org> <476CBD9B.9070203@linux.vnet.ibm.com> <Pine.LNX.4.64.0712221140330.7460@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0712221140330.7460@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 22 Dec 2007, Balbir Singh wrote:
>> Andrew Morton wrote:
>>> On Fri, 21 Dec 2007 00:23:58 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>>>> Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was
>>>> felt that control_type might not be a good thing to implement right away.
>>>> We can add this flexibility at a later point when required.
> 
> Not studied closely, but your patch looks both too much and too
> little to me, Balbir.
> 
> Too much in that it appears to bundle in some significant little
> locking changes without any mention in the commment.
> 

I can create and send across a new changelog, but what it does is make
the check for !pc under the page_group lock (lock_page_group()). I sent
out a pointer to the URL of our discussion. Yes, I should have been more
willing to write a more detailed changelog.

> Too little in that it leaves behind lots of junk relating to the
> different control_types: the enums, the different kinds of call
> that needn't now be different, no change to the various callsites.
> Needs more cleanup, I'd say.  Of course, that could be yet another
> separate patch.
> 

Yes, my dilemma, that still remains (Andrew very aptly noted) is that we
have a bunch of patches adding in the feature and then a patch removing
it. I have noted your point, which is correct about cleaning up unused
parameters.

>>> Gee the memory controller patchset is turning into a mess.
> 
> A mess indeed.
> 
>> Yes, the patchset has expanded and we have several useful bug fixes and
>> cleanups and some new features.
> 
> Hah, a career in politics beckons ;)
> 
>>> Hopefully it'll look a bit better once I do a big patch-folding but we
>>> still have patches interesecting everywhere and now we have patches which
>>> add a feature and later ones which take it away again.
>>>
>> I think folding will help. I understand your concern w.r.t getting the
>> correct set of patches with a good changelog.
>>
>>> But I don't think it's worth the time and risk of a huge
>>> rip-up-and-refactor.
>>>
>> I agree, given the proximity of the new merge window for 2.6.25.  We
>> could review the patches after folding them and see how to consolidate
>> further in case the patches continue to look messy.
> 
> Personally, I think it could benefit a lot from a rip-up-and-refactor.
> But if we're rushing headlong for 2.6.25, yes, I agree it's too late.
> And I'm afraid it's not something I can volunteer for at this time.
> 
> Hugh

I want to spend as much time as possible testing the memory controller.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
