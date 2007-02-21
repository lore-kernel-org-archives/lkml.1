Return-Path: <linux-kernel-owner+w=401wt.eu-S1423169AbXBUV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423169AbXBUV0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423161AbXBUV0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:26:16 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:8407 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423152AbXBUVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:25:41 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
	 <1172088050.8577.71.camel@imap.mvista.com>
	 <1172090603.25076.127.camel@localhost.localdomain>
	 <1172090973.8577.77.camel@imap.mvista.com>
	 <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 13:23:30 -0800
Message-Id: <1172093010.8577.95.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 13:06 -0800, Linus Torvalds wrote:
> 
> On Wed, 21 Feb 2007, Daniel Walker wrote:
> > 
> > Here's the final commit from the bisect which caused it . It says "No
> > changes to existing functionality" ?
> 
> Ok, it wouldn't be the first time some change that is supposed to change 
> nothing does actually change something.

Yeah , maybe I screwed something up. First time I've done a git bisect.

> That said, one thing to worry about when doing bisection: the kernel 
> configuration.
> 
> If you always just do "make oldconfig" or something, the kernel config for 
> the thing you test will depend on the _previous_ kernel you compiled, and 
> that is not always what you want. I've once had a failing kernel, did 
> bisection, and it turned out that since I had gone back in time to before 
> the option that caused the failure even existed, I had (by mistake) then 
> compiled some of the later kernels without that option enabled, and called 
> them "good". 

In this case I don't think anything was specifically turned on, beyond
SMP. For instance HRT/dynamic tick was off.

I didn't run "make oldconfig", but just running "make" asked for options
that just got added, which was nice.

> The end result: "git bisect" didn't actually end up pointing to the right 
> commit, just because I had effectively lied to it.
> 
> That said, considering that you did get a commit that doesn't look 
> entirely unlikely (and that clearly changes things that are relevant), I 
> suspect you did actually find the right one.

I think if it's not that exact commit it's still one in that set. I
mainly wanted to confirm that it was an hrt/dynamic tick issue , and not
some left field patches..

Daniel

