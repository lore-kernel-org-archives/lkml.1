Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZKLLZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZKLLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZKLLZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:25:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZKLLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:25:55 -0500
Date: Thu, 12 Nov 2009 12:25:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091112112544.GD24684@elte.hu>
References: <20091110193705.GA9011@elte.hu>
 <4AF9C402.9040800@kernel.org>
 <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
 <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu>
 <4AFAAC32.4020104@kernel.org>
 <20091111195751.GA13574@elte.hu>
 <4AFBDF43.3010703@kernel.org>
 <20091112103639.GB24684@elte.hu>
 <4AFBEA4B.4070100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFBEA4B.4070100@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> This really depends on personal tastes.  When trying to use long 
> string literals, there are several choices.
> 
> 1. Use broken strings.
> 
> 				printk("blah blah blah blah "
> 				       "blah blah blah blah\n");
> 
> 2. Push it into new line and unindent it.
> 
> 				printk(
> 	"blah blah blah blah blah blah blah blah\n");
> 
> 3. Restructure code so that the literal ends up in outer block.
> 
> 	printk("blah blah blah blah blah blah blah blah\n");
> 
> I prefer the first choice.  The third would be nice if it's trivial to 
> do but I don't think it should dictate the code structure.  The second 
> one, I don't know.  Some people like that and grep will be happy with 
> it but it just seems very disturbing to my eyes.

My preferred choice is:

  4. Change "blah blah blah blah blah blah blah blah\n" to "blah\n" - 
     the user really does not win much from the repetition.

Seriously, if you _ever_ get into a 'hm, the string is too long' 
situation, you should ask yourself two fundamental questions:

  a) Is the user really interested in this small novel?

  b) Is this a side-effect of a bloated function having too deep
     indentation?

IMHO, in the specific case at hand, both a) and b) apply:

                                err = "failed to extend area map of "
                                        "reserved chunk";

the indentation is a bit too deep, and the message is too chatty - the 
output itself is:

 PERCPU: allocation failed, size=1024 align=32, failed to extend area map of reserved chunk

A better/shorter message would be:

 percpu: 1024 bytes allocation failed: could not extend reserved chunk area map

This formulation is a bit shorter and i doubt the align parameter really 
needs printing - it's almost always the same and other context will tell 
us what it is anyway.

	Ingo
