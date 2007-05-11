Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbXEKRYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbXEKRYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759736AbXEKRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:24:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:7072 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596AbXEKRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l7jmoSiU0WGuLMCpCWvq39WMw/P4lph+0JYjJZ+48hd5B1/fWN2Bxz6hsjvxFr3VR6g10fn8LtKYaKF0IqpFvJZakaoxB/DLy9taygb7iM+VSPzeN6sDQYmQZl+Cdt+7cRwbug+fMtKSHgArfPrxZ1NGcG8PpJdgt7BgCs2OduI=
Message-ID: <4644A637.1060507@gmail.com>
Date: Fri, 11 May 2007 19:21:59 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, bunk@stusta.de,
       randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
References: <4643BDF2.9030105@gmail.com>	<20070511114605.4c2698ec@the-village.bc.nu>	<46447ABF.3000004@gmail.com> <20070511154009.50c8bae0@the-village.bc.nu>
In-Reply-To: <20070511154009.50c8bae0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2007 04:40 PM, Alan Cox wrote:

>> But it's not a style issue. It's solving a problem. The adresses from this 
>> tag are the only addresses available from the binary and as such are 
>> mistaken for maintainer/general contact addresses which they often are not.
> 
> Which is why you want MODULE_MAINTAINER()

Right. Or want_ed_ at least.

>> contacted for the driver. Giving that MODULE_MAINTAINER was concluded to not 
>> be a good idea
> 
> Not my fault, not my problem, take it back up with the objectors

The thing is, Adrian Bunk had a valid argument against it and it's one of 
the arguments that exist against MODULE_AUTHOR as well; the address would 
live on "forever" as part of Linux installs.

So say I'm maintaining driver foo. Then the dog eats my foo and I can't 
maintain it anymore since I can't test; off goes a patch removing 
MODULE_MAINTAINER from the source and/or the MAINTAINERS file but I can't do 
anything about all the existing installs that proudly announce my address as 
a contact for foo. The way I _can_ do something about existing installs is 
to not make people believe there's a maintainer contact address there in the 
first place so that people know they need to look elsewhere.

Now, unlike Adrian (it seems) I'm not actually all that worried about the 
"forever" bit. People with old Linux installs around should quite possibly 
not be overly worried about so I'm still not against MODULE_MAINTAINER but 
it is a valid argument. And no, it's not the same as "the source tree on the 
user's box". Why would there even be any such thing?

> The author also can't update the kernel rpm packages provided by the
> distibutor where 99.99% of the users get their data.

Right. So let's stop putting in confusing data in the first place. This is 
what the patch that you objected to advised (<-- s!).

> I have no problem with people using name only, or name and email. Its
> not my problem what they use.

Your argument is inconsistent. The current comment says:

/* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>]

After my trivial patch, it says:

/* Author, ideally of form NAME[, NAME]*[ and NAME] */

So what do you find _better_ about the first form? I've been going on about 
the problems of it only one of which is email adresses geting outdated 
(which happens for multiple reasons; owner graduating, ISP mergers, dog 
eating owner's foo, owner dying, dog dying and owner getting so depressed he 
just can't handle it all anymore, what have you) and as such putting them 
into the binary is not something to generally advise.

>> Finally, at the very, very least the advice to add more future problems 
>> should be killed and that's the only thing _this_ particular patch does.
> 
> Adding new drivers causes future problems, lets stop that too ?

That's being argumentative just for the heck of it. (N+1) future problems 
are not better than N future problems.

The patch as submitted stands. The advice of putting in an email address is 
generally bad advice. Stop giving generally bad advice.

Rene.

