Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXBYLyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXBYLyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964807AbXBYLyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:54:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:34288 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbXBYLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RkRdJaBlMzRysGvfHkk/ZKN2MeBR0+1R5xXz/lb7qKqg4qVDvqit45evleyTVVFcxGq8BvsfUrru9paQrslr5zOhnD7tHZOB2MCzspQO2gad5aec6qkKwzzAQOnjqhbHtKOsKfUJFBgqwHgh4CCWXZF6sWtjLeKVMEUhbieMk50=
Message-ID: <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
Date: Sun, 25 Feb 2007 03:54:47 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: GPL vs non-GPL device drivers
Cc: davids@webmaster.com, "v j" <vj.linux@gmail.com>,
       trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <20070225104211.GB2045@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	 <20070225104211.GB2045@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> Ok, but this is not realistic. I agree that if Evil Linker only adds
> two hooks "void pop_server_starting(), void pop_server_stopping()", he
> can get away with that.
>
> But... how does situation change when Evil Linker does #include
> <pop3/gpl_header_file_with_some_inline_functions.h> from his
> binary-only part?

There is no such thing as a "GPL header file".  There is an original
work of authorship, that is, your POP server.  There is a modified
work of authorship (not exactly a "derivative work", but let's call it
an Annotated Edition in order to bring it into the "derivative works"
category), that is, your POP server as altered by the Evil Linker in a
coherent and readable way.  There is an independent work of
authorship, the Evil Linker's program.  And there is a claim that the
independent work of authorship infringes on the original author's
copyright in the POP server.

If the sole factual basis for that claim is that the Evil Linker's
program contains #include "what_you_said.h", then it's not going to
fly in court (IANAL, TINLA).  The #include directive itself is not
protectable expression, and anything that winds up in the Evil
Linker's binary is either a "method of operation" or "fair use" under
a "minimum practical amount of copying needed to accomplish a
sanctioned purpose" standard.  Interoperation, even competitive
interoperation and circumvention of partner licensing programs, is a
sanctioned purpose under US law.  You have to go pretty far out of
your way to find a case like Atari v. Nintendo in which the court
ruled that the competitor had been too lazy or venal in its reverse
engineering methodology not to be entitled to copy the bits needed to
interoperate.

> I believe situation in this case changes a lot... And that's what
> embedded people are doing; I do not think they are creating their own
> headers or their own inline functions where headers contain them.

Remember, I am not defending people who hack the kernel and then don't
release the source code to their hacked kernel.  (I'm not really
defending people who hack the kernel and write a closed-source
application locked to those hacks, either, although I am saying that
calling such tactics "illegal" or "GPL violation" is irrelevant and
wrong-headed.)  And when what they in fact did was to riffle shuffle
together two drivers from Linus's tarball and change the names of the
symbolic constants to match their hardware interface (itself doubtless
a half-assed clone of someone else's), there's no excuse for GPLing
the result.

But a 20KLoC 3-D graphics driver that happens to #include
<linux/whatever.h> is not thereby a "derivative work" of the kernel,
no matter how many entrypoints are labeled EXPORT_SYMBOL_GPL or
provided as inline functions.  And under the Lexmark standard,
MODULE_LICENSE("GPL") with a disclaimer in the doco is by far the
sanest way to deal with the EXPORT_SYMBOL_GPL mind games, and likely
(IANAL, TINLA) to be endorsed by any court in the US and probably lots
of other places too.  Especially when the graphics chip maker explains
that keeping their driver source code closed isn't really an attempt
to hide their knowledge under a bushel basket.  It's a defensive
measure against having their retail margins destroyed by nitwits who
take out all the busy-wait loops and recompile with -O9 to get another
tenth of a frame per second, and then pretend ignorance when
attempting to return their slagged GPU at Fry's.

Cheers,
- Michael
