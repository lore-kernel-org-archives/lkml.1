Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbYAaKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbYAaKVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932689AbYAaKVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:21:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:52186 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbYAaKVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BHUFpOe4LcHAj7aCx7s3peSujDiA4qrgnaSeTHT3xxLARfJ9rbJ7aqeB/EDPW4szl6coh0f7IxH+UfcJ9zOtdsAmSXWZU9Itdmg8tedACJV4UxyvoHlk8ZiHaLR2O71X0NHEDEd+W1EOMpTqLywX9y48whxuvt41UBKuMaCTqbY=
Subject: Re: about relocs.c on x86
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080131101111.GB11867@elte.hu>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
	 <20080131095223.GA11867@elte.hu> <1201773740.23523.17.camel@brick>
	 <20080131101111.GB11867@elte.hu>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 02:21:38 -0800
Message-Id: <1201774898.23523.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 11:11 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > > during the big first phase of unification we generally kept file 
> > > names untouched if they were only present in one of the previous 
> > > architectures. I.e. pure 32-bit and pure 64-bit files were not 
> > > renamed to _32/_64.
> > > 
> > > Now that we've got lots of unified 32/64-bit files it might make 
> > > sense to rename the 'standalone' ones into _32/_64 if they share the 
> > > same directory with 32/64-bit source files - to reduce the 
> > > confusion. And given that for example 
> > > arch/x86/boot/compressed/misc.c is unified while 
> > > arch/x86/boot/compressed/relocs.c is 32-bit only, i'd agree with 
> > > your observation. Feel free to send a rename patch for such cases.
> > 
> > I'd argue that eliminating the _32/_64 suffixes through unification 
> > and not adding any more would be better.  Renaming at this point seems 
> > like the wrong side of the cost/benefit line.  When the makefiles 
> > finally get unified, that would be a natural list of what is 32 
> > bit-only and what is 64 bit-only, and additional suffixes wouldn't add 
> > much to that.
> 
> no strong opinion from me - but i think it should be obvious to the 
> developer when they are looking at a .c file that it's 32-bit only (or 
> 64-bit only). I.e. the default is that whatever .c file we look at is 
> unified - and in that sense relocs.c breaks that general expectation.
> 
> In fact renaming it to _32.c might spur its unification: people might 
> say "hm, this would be handy on 64-bit as well". We might even do that 
> to directories - so that for example arch/x86/math-emu/ would become 
> arch/x86/match-emu_32/.

They could just as easily do that in the original file rather than
renaming it once and then renaming it again someday when it has 64
bit functionality.  It's the potential for this double-rename that
really turns me off the idea.

> 
> ( Hey, and maybe someone is crazy enough to try to port the math-emu 
>   code to 64-bit and boot Linux up on 64-bit with all user-space FPU ops 
>   emulated. It would be one of the most useless hacks of all times, and 
>   that certainly has a certain kind of sick appeal to it, doesnt it? ;-))
> 
> but it's really not a big issue, we can certainly leave it alone and 
> observe the situation as more stuff gets unified. I'd expect it all fall 
> into place naturally.

Again, I can't tell people how to spend their time, but there isn't much
benefit over checking the makefile to see if it is shared for this case
that I can see.

IMHO

Harvey

