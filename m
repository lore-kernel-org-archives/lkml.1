Return-Path: <linux-kernel-owner+w=401wt.eu-S1946421AbXBIMjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946421AbXBIMjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946428AbXBIMjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:39:02 -0500
Received: from javad.com ([216.122.176.236]:4038 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946421AbXBIMjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:39:00 -0500
From: Sergei Organov <s.organov@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.A. =?utf-8?B?TWFnYWxsw4PCs24=?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
Date: Fri, 09 Feb 2007 15:38:39 +0300
In-Reply-To: <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 8 Feb 2007 14:03:06 -0800 (PST)")
Message-ID: <87abznsdyo.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Thu, 8 Feb 2007, Linus Torvalds wrote:
>> 
>> But THE CALLER CANNOT AND MUST NOT CARE! Because the sign of "char" is 
>> implementation-defined, so if you call "strcmp()", you are already 
>> basically saying: I don't care (and I _cannot_ care) what sign you are 
>> using.
>
> Let me explain it another way.
>
> Say you use
>
> 	signed char *myname, *yourname;
>
> 	if (strcmp(myname,yourname) < 0)
> 		printf("Ha, I win!\n")
>
> and you compile this on an architecture where "char" is signed even 
> without the explicit "signed".

As far as I can read the C99 standard, the "char", "signed char", and
"unsigned char", are all different types:

 "The three types char, signed char, and unsigned char are collectively called
  the character types. The implementation shall define char to have the same range,
  representation, and behavior as either signed char or unsigned
  char.(35)
  ....
  (35) CHAR_MIN, defined in <limits.h>, will have one of the values 0 or
       SCHAR_MIN, and this can be used to distinguish the two
       options. Irrespective of the choice made, char is a separate type
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       from the other two and is not compatible with either.
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 "

If so, then the code above is broken no matter what representation of
"char" is chosen for given arch, as strcmp() takes "char*" arguments,
that are not compatible with either "signed char*" or "unsigned char*".

-- Sergei.
