Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXEKOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXEKOTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbXEKOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:19:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:34576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbXEKOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HilFHtPAWBHzBjLJO0Tbg1H4tgJMOPKU155lZvktHyja+ZSPIuUdrmSwyw6zK0KjkQ/XAZ/WIxkfcwXyTUyBb4ze/lXSfo9FB/5IHxJtA7sD6Zu7ARlPgBSUmt7wcVLCCDzdhzkRlXNk3PzShVaw5v9iurLnRxFWKGN8FgIKQ5E=
Message-ID: <46447ABF.3000004@gmail.com>
Date: Fri, 11 May 2007 16:16:31 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, bunk@stusta.de,
       randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
References: <4643BDF2.9030105@gmail.com> <20070511114605.4c2698ec@the-village.bc.nu>
In-Reply-To: <20070511114605.4c2698ec@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2007 12:46 PM, Alan Cox wrote:

>> The email address is the problem I was trying to fix; with multiple current 
>> and non-current authors and maintainers who might not even be authors the 
>> address(es) available from the tag confuse the issue of whom to contact. 
>> It's moreover also information that easily outdated.
>>
>> A bit more than half of the tags in the tree don't include an email address 
>> already and I'll submit patches removing more...
> 
> Please don't do this
> 
> NACK this change.
> 
> Whether someone puts their email address into the entry is their own
> business. We do not need a style police for module author entries.

This particular patch just deletes the _advice_ to add an address; if you'd 
consider it a style issue, you shouldn't be objecting.

But it's not a style issue. It's solving a problem. The adresses from this 
tag are the only addresses available from the binary and as such are 
mistaken for maintainer/general contact addresses which they often are not.

The first issue is multiple current and non-current authors only one of 
which should be contacted for the driver or even _none_ of which should be 
contacted for the driver. Giving that MODULE_MAINTAINER was concluded to not 
be a good idea, a maintainer has no place to override an address from 
MODULE_AUTHOR.

Then the next issue is email addresses getting outdated. I've had my share 
of bug reports both bounce and not bounce but just not getting any reply and 
I can assure you it's the kind of frustrating experience that makes you just 
stop trying. From source and/or MAINTAINERS file they can be deleted but 
they can't ofcourse from the binary installs on user machines. Even the 
person listed can't do that, which is issue 3.

You earlier objected to removing the MODULE_AUTHOR tag outright on legal 
grounds but you yourself are one of the people using only a name and not an 
address in the tag. In fact, most of the core contributors are, so I assume 
you don't have that same objection again.

My specific angle is old PC hardware where the drivers have outlived their 
authors (various ISA junk, legacy CD-ROM, what have you) where I or some 
other newbie might want to take on maintainership of a driver. I can add 
myself to MAINTAINERS but not to binary installs, and in fact even on a 
source level the addresses from the MODULE_AUTHOR tag confuse the issue of 
who's responsibe for the thing.

This specific problem of mine would be solved by me just deleting the 
addresses from the specific drivers I'm interested in and just not bothering 
with anything else. This means the problems outlined above would just live 
on for everything else though and we happily continue to frustrate bug 
reporters and maintainers.

Finally, at the very, very least the advice to add more future problems 
should be killed and that's the only thing _this_ particular patch does.

Rene.

