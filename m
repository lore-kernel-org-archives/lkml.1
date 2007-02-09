Return-Path: <linux-kernel-owner+w=401wt.eu-S1423200AbXBIAm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423200AbXBIAm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423185AbXBIAm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:42:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47352 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423156AbXBIAmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:42:55 -0500
Date: Thu, 8 Feb 2007 16:42:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, David Rientjes wrote:
> 
> Your struct:
> 
> 	struct dummy {
> 		int flag:1;
> 	} a_variable;
> 
> should expect a_varible.flag to be signed, that's what the int says.  

No it's not.

You just don't understand the C language. 

And if you don't understand the C language, you can't say "that's what the 
int says". It says no such thing.

The C language clearly says that bitfields have implementation-defined 
types. So when you see

	struct dummy {
		int flag:1;
	} a_variable;

if you don't read that as "oh, the sign of 'flag' is implementation- 
defined", then you simply aren't reading it right.

Is it "intuitive"? Nobody ever really called C an _intuitive_ language. C 
has a lot of rules that you simply have to know. The bitfield sign rule is 
just one such rule.

> There is no special case here with regard to type.

Sure there is. Read the spec.

I don't understand why you are arguing. YOU ARE WRONG.

Bitfields simply have implementation-defined signedness. As do enums. As 
does "char". It really is that simple. 

The *real* special case is actually "int" and "long". In many ways, the 
fact that those *do* have a well-specified signedness is actually the 
exception rather than the rule.

Most C types don't, and some you can't even tell (do pointers generate 
"signed" or "unsigned" comparisons? I'll argue that a compiler that 
generates signed comparisons for them is broken, but it tends to be 
something you can only see with a standards- conforming proghram if you 
can allocate memory across the sign boundary, which may or may not be 
true..)

			Linus
