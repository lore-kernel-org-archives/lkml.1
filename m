Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbYHOOtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbYHOOtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYHOOtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:49:23 -0400
Received: from mercury.realtime.net ([205.238.132.86]:46180 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753141AbYHOOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:49:22 -0400
In-Reply-To: <20080814221214.GG30057@kroah.com>
References: <for-27-patch1-0@bga.com> <for-27-patch9@bga.com> <20080712041137.GA5933@kroah.com> <e6b3109a0ab047bea58ceecb8734761d@bga.com> <0a67ecbf69649dce778db1b463e59c3a@bga.com> <ad61f8387a737bc410e9d6dc3a8a5b63@bga.com> <20080717070759.GE22090@kroah.com> <20080806093118.05396ad4@hyperion.delvare> <20080814221214.GG30057@kroah.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a12d8dc5899dc8d07e0182576941a82a@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Fri, 15 Aug 2008 09:50:07 -0500
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14, 2008, at 5:12 PM, Greg KH wrote:

> On Wed, Aug 06, 2008 at 09:31:18AM +0200, Jean Delvare wrote:
>> Hi Greg,
>>
>> On Thu, 17 Jul 2008 00:07:59 -0700, Greg KH wrote:
>>> On Wed, Jul 16, 2008 at 05:18:18AM -0500, Milton Miller wrote:
>>>>
>>>> Greg,
>>>>
>>>> Please respond to this email and explain why the patch
>>>>
>>>> pci: dynids.use_driver_data considered harmful
>>>>
>>>> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.1/index.html#2188
>>>>
>>>> should not be applied.   I am not arguing the correctness of
>>>> the removed code, rather its utility and benefit to the linux
>>>> community.
>>>
>>> (...)  I'll try to get
>>> to this by Monday, but my original point still stands, this was
>>> implemented for a reason,
>>
>> Not a good enough argument, sorry. There have been many cases in the
>> past where code has been withdrawn after some times because we
>> realized that we got it wrong in the first place.
>
> Fair enough :)
>
>> So, please explain what the current code is good for. Honestly, my
>> initial reaction to Milton's proposal was "what an idiot, this flag is
>> there for an obvious safety reason and we don't want to remove it" but
>> after reading both his arguments and the code, I found that I have
>> nothing to backup my claim. If you do, please let us know your
>> technical reasons.
>
> The technical reason was that this flag was needed to let some drivers
> work properly with the new_id file, right?
>
> If the flag goes away, they break from what I can tell.

That is not a detailed technical argument, its an  assumption.

>
>>>                           saying that not enough drivers use it 
>>> properly
>>> does not make the need for it to go away.  It is required for them, 
>>> so
>>> perhaps the other 419 drivers also need to have the flag set.  That's
>>> pretty trivial to do, right?
>>
>> If you are suggesting to blindly set the flag to all PCI drivers (or
>> even just all the ones which make use of the driver_data field -
>> doesn't make a difference), this simply shows how useless this flag 
>> is.
>> If you don't, then one would have to check the code of all drivers and
>> add validation code for the driver_data value; but then this no longer
>> falls into the "trivial" category.
>
> It's pretty "trivial" to look to see if the field is set in the pci_id
> structure, that should be all that is needed, right?


So please identify at least one such driver where the only correct 
answer is 0.  I even made it easy for you, i identified which drivers 
set dynamic_id and how.  I identified specific drivers where its the 
wrong answer.

So:  If you are arguing the code is still needed, please identify  at 
least one case that it is correct.  (Oh, I don't buy that if 0 is safe 
but 1 is equally safe, that the existing code is correct).

milton

