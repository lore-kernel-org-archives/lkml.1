Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYHHPg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYHHPg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYHHPgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:36:50 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55087 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYHHPgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:36:49 -0400
Message-ID: <489C681B.1020805@keyaccess.nl>
Date: Fri, 08 Aug 2008 17:36:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: including .c files ?
References: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com>
In-Reply-To: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 13:25, Frans Meulenbroeks wrote:

> I was wondering how people feel about including .c files in other .c
> files.
> 
> I saw a few occasions of this. Triggered by that observation I
> decided to do a grep for this (on 2.6.25.7 as that was the one I had
> handy at that moment). Some 268 .c files are included. Seems an awful
> lot for me.
> 
> Do people feel this is good practice? I understand that sometimes it
> is useful (and then you might need to decide on whether to include a
> .c file or to have a .h file with code), but in other places it is
> probably less relevant.
> 
> Generally I would expect that if the .c file contains some standalone
>  functionality then it should probably be a .c file on its own with a
>  well defined interface.
> 
> Curious what others think about this. As attachement I've added the
> output of the grep (slightly edited to remove some false positives,
> like those from the Documentation and scripts directories and those
> who are obviously comments).

As you posted, many of these are in sound/ and many of those #define a 
model and then including the "real source file". Can't say I've been 
very keen on that either and in those cases using a -D commandline 
#define might be better especially since I believe that's actually very 
easy these days.

I also keep a local driver here though that #defines some 50 items and 
then includes the source so that the driver for another version of the 
card can just redefine those and keep the code itself the same (as a 
coincidence, I was just porting that one forward in fact).

This general problem more or less is "library code". Say I have some 
code that I want to use in two different drivers -- I can't just link it 
into both due to symbol clashes if I'd try to then _load_ both drivers. 
So I then have to structure the library code as a completely seperate 
module that both drivers depend on and for small stuff that's sometimes 
just really silly. You still definitely don't want two copies of the 
code to avoid all the usual problems of stuff getting out of sync so a 
solution is to just #include the library code in both after which its 
identifiers can be static.

If you think about it -- in C, #include really at least conceptually 
means "cut & paste this in here, please" meaning headers are not 
anything special and .h and .c seperation is a mere convention.

As we all know, conventions exist _only_ to be violated...

Rene.
