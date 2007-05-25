Return-Path: <linux-kernel-owner+w=401wt.eu-S1764296AbXEYQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764296AbXEYQzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXEYQza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:55:30 -0400
Received: from keil-draco.com ([216.193.185.50]:50138 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbXEYQz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:55:29 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Fri, 25 May 2007 12:55:21 -0400
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nitin Gupta <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Andrey Panin <pazke@donpac.ru>, Bret Towe <magnade@gmail.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com> <a781481a0705250537o768c609evaf32d517444f7aca@mail.gmail.com> <1180100304.5864.60.camel@localhost.localdomain>
In-Reply-To: <1180100304.5864.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251255.22600.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 09:38:24 Richard Purdie wrote:
<snip>
> > > I am however still strongly of the opinion that we should just use the
> > > version in -mm (which is my latest version).
> >
> > Right, if the difference is anything >10%, code cleanup does lose
> > its attractiveness.
>
> Agreed, and I still have the security and maintainability concerns. Add
> them all together and its more unattractive.

I can understand the security concerns, but since none of the bounds checking 
has been removed there shouldn't be any difference from a security  
viewpoint. I have maintained the code to a MUD server at one point - I can 
guarantee that it had a lot more code than the LZO code - and it was so 
highly customized that no patches to the core code from anywhere *outside* 
that games "coders" would apply. This means that every one of those patches 
had to be done manually - sure, it was a massive PITA - but it was worth it.

In other words - yes, it will make maintaining the code harder, but the fact 
that the code matches the kernels style and is "lightweight" compared to the 
original userspace code *and* Richards "miniLZO" should mitigate this.

As to the performance - I can see absolutely no reason why the minimal version 
shouldn't perform the same (or better). The kernel codes memset and memcpy 
routines have been heavily tested *and* optimized over the years and moving 
from macro's to inline functions shouldn't have impacted performance at all. 
I will be testing the two code bases myself in a little bit - I'm more than a 
little paranoid and don't like the idea of trusting anyone with a "competing 
project" for all testing.

DRH
