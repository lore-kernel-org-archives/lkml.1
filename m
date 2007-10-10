Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbXJJQlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbXJJQlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJJQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:40:52 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:35728 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbXJJQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SEoDgWcI/sH++jYV6DC/D7MRIRAZHo9Bhw4wsjXNHjrweB06Ny2WWFBmXPXtokrAoA57f08s5HCHUPwXPNlNzVowhLy4j9JRB2Rx7veaTD88jurN4ktEBdxNZTLCghv7+4gVJY2KIrSqfZFzJw482Oz64AUB8/NG+jkFCjHzQI4=
Message-ID: <470D0087.3050606@gmail.com>
Date: Wed, 10 Oct 2007 20:40:39 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       Jiri Slaby <jirislaby@gmail.com>, daniel@qanu.de,
       linux-kernel@vger.kernel.org, holger@qanu.de,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 3/3] V4L: cinergyT2,	remove bad	usage
 of ERESTARTSYS
References: <24841282012868130110@pripojeni.net>	<1191979260.5492.32.camel@gaivota> <470C5294.8060502@linuxtv.org>	<1192030541.5896.54.camel@gaivota>	<20071010155920.GC22618@devserv.devel.redhat.com> <1192033070.5896.77.camel@gaivota>
In-Reply-To: <1192033070.5896.77.camel@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Em Qua, 2007-10-10 Ã s 11:59 -0400, Alan Cox escreveu:
>> On Wed, Oct 10, 2007 at 12:35:41PM -0300, Mauro Carvalho Chehab wrote:
>>> Em Qua, 2007-10-10 Ã s 00:18 -0400, Michael Krufky escreveu:
>>>> Is this illegal as per kernel codingstyle?
>>> Yes, it is. CodingStyle states:
>> <rant>
>> No.. "Illegal" means prohibited by law. Its merely wrong 8)
>> </rant>
> 
> LOL
> 
>>> The proper fix is just to replace the offended code by this:
>>>
>>> err=foo();
>>> if (error)
>>> 	goto error;
>> Lots of code uses
>>
>> 	if ((err = foo()) < 0)
>>
>> so I would'y worry too much. The split one however clearer and also
>> safer.
> 
> Yes, this is not a severe CodingStyle violation. Still, the above code
> is better than the used one.
> 
> Since, on your example, it is clear that the programmer wanted to test
> if the value is less than zero. 
> 
> The code:
> 
> 	if ( (err=foo()) )
> 
> should also indicate an operator mistake of using =, instead of ==.
> 
> Probably, source code analyzers like Coverity will complain about the
> above.
> 
> If not violating CodingStyle, I would rather prefer to code this as:
> 	if ( !(err=foo() ) 
> or, even better, using:
> 	if ( (err=foo()) != 0)
> 
> clearly indicating that it is tested if the value is not zero.
> 
> Even being a quite simple issue, I would prefer if Jiri can fix it.
> 


When you have only some few lines of code you can write

 err = foo()
 if (err) {
  do whatever
 } 

doesn't matter ..

But when you have hell a lot of code, checking error's what you 
mention is insane.

ie,

if ((err = foo()) expr ) is better.

http://lkml.org/lkml/2007/2/4/56

Manu
