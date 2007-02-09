Return-Path: <linux-kernel-owner+w=401wt.eu-S1946524AbXBIP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946524AbXBIP6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946555AbXBIP6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:58:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57121 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946524AbXBIP6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:58:20 -0500
Date: Fri, 9 Feb 2007 07:58:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <s.organov@javad.com>
cc: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C2=B3n?= <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87abznsdyo.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Feb 2007, Sergei Organov wrote:
> 
> As far as I can read the C99 standard, the "char", "signed char", and
> "unsigned char", are all different types:

Indeed. Search for "pseudo-unsigned", and you'll see more. There are 
actually cases where "char" can act differently from _both_ "unsigned 
char" and "signed char".

> If so, then the code above is broken no matter what representation of
> "char" is chosen for given arch, as strcmp() takes "char*" arguments,
> that are not compatible with either "signed char*" or "unsigned char*".

..and my argument is that a warning which doesn't allow you to call 
"strlen()" on a "unsigned char" array without triggering is a bogus 
warning, and must be removed.

Which is all I've ever said from the beginning.

I've never disputed that "char" and "unsigned char" are different types. 
They *clearly* are different types. 

But that doesn't make the warning valid. There is a real need for NOT 
warning about sign differences.

But this argument has apparently again broken down and become a "language 
lawyer" argument instead of being about what a reasonable compiler 
actually can and should do.

As long as gcc warns about idiotic things, the kernel will keep shutting 
that warning off. I'd _like_ to use the warning, but if the gcc 
implementation is on crack, we clearly cannot.

There's simply an issue of "quality of implementation". In the case of 
this warning, gcc is just not very high quality.

		Linus
