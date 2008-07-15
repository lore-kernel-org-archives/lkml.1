Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYGOWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYGOWZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbYGOWZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:25:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:36719 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759067AbYGOWY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:24:59 -0400
Date: Tue, 15 Jul 2008 15:24:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
 <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, david@lang.hm wrote:
>>
>> a kernel compiled with this option would just drop-in to an older distro with
>> zero impact. newer distros that have updated their userspace tools could
>> compile with different options and have the firmware seperate.
>
> The 'zero impact' is what doesn't make sense here.
>
> You are supposed to be able to run ol distributions, yes.
>
> But that doesn't mean that you can necessarily just plop things in the
> same way as you always did before.
>
> For example, you have to rewrite your distro's initrd if you are using
> modules. You cannot just re-use the modules in the distro initrd. So doing
> a new kernel has _never_ been 'zero impact' in the sense that you could
> just switch vmlinux files around.

this time I will call 'strawman'. we've been required to put in the 
appropriate modules ever since modules were introduced. as Jeff gave 
examples of the userspace tools have been taking care of that for many 
years (and on distros where they don't take care of that you go with 
monolithic kernels), but they don't take care of firmware in many cases.

> (Btw, I personally actually want my kernel to be _truly_ zero impact, but
> that also means that I don't use modules - because that way I really can
> avoid changing even the initrd image too. But that also already works)

I do the same thing 99% of the time.

> Why is it suddenly so important that a kernel be 'zero impact' for that
> module case, when it's never been zero impact for that case before? You
> had to rewrite the initrd to begin with, but now you're not willing to do
> it again, just because you have to rewrite it slightly _differently_?

becouse the tools that wrote the initrd already put the modules in. I 
don't maintain those tools, they came with the distro. we're just asking 
to not require those tools to be updated immediatly.

David Lang

> THAT is what I find so odd. The inability to accept just a slight change
> in kernel build.
>
> But whatever. This really isn't worth it. The request_firmware() thing
> will clearly happen regardless, and as long as the backwards compat code
> is small and Jeff writes it, what do I care? Even if I think it looks
> largely pointless..
>
> 			Linus
>
>
>
