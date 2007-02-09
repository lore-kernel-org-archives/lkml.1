Return-Path: <linux-kernel-owner+w=401wt.eu-S1946069AbXBIDdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946069AbXBIDdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 22:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946054AbXBIDdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 22:33:07 -0500
Received: from keil-draco.com ([216.193.185.50]:50875 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946069AbXBIDdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 22:33:06 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 22:33:04 EST
From: "D. Hazelton" <dhazelton@enter.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Date: Thu, 8 Feb 2007 22:27:43 -0500
User-Agent: KMail/1.9.5
Cc: David Rientjes <rientjes@google.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com> <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702082227.43373.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 19:42, Linus Torvalds wrote:
<snip>
> Most C types don't, and some you can't even tell (do pointers generate
> "signed" or "unsigned" comparisons? I'll argue that a compiler that
> generates signed comparisons for them is broken, but it tends to be
> something you can only see with a standards- conforming proghram if you
> can allocate memory across the sign boundary, which may or may not be
> true..)

And this is, because as Dennis Ritchie says in "The Development of the C 
Language" (http://cm.bell-labs.com/cm/cs/who/dmr/chist.html) C evolved from a 
typeless language, B - which, in turn, had originated as a stripped down 
version of BCPL. B and BCPL  used a "cell addressing" scheme, but because of 
the move off the PDP-7, and the difficulties run into by Ken Thompson in 
rewriting the code for Unix in B (the original Unix was written in assembler) 
types were added - 'char' and 'int'. These represented the byte and word 
addressing modes of the PDP-11, and were needed because Ritchie was in the 
process of having the compiler generate assembler instead of "threaded code". 
This "NB" language, after also having data structures added and the rules for 
defining pointers finalized, was renamed "C" by Ritchie.

So almost all the rules around the signs of types are because of a single, 
historical machine. Hence the rules about "char" being unsigned by default 
and "int" being signed by default are because of the nature of the PDP-11. 
The implementation defined nature of bitfields is because Dennis Ritchie had 
freedom there - the PDP-11 didn't have anything like them in the hardware and 
they were being stuffed in to make Thompsons life easier.

Now: There is no reason for the behavior that came from the nature of the 
PDP11 to have survived, but because it was in "The White Book" it made it 
through the ANSI standardization process.

Now that this history lesson is over...

DRH
