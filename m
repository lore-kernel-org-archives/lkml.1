Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbYGOVpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbYGOVpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYGOVpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:45:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbYGOVpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:45:21 -0400
Date: Tue, 15 Jul 2008 14:43:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
 <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, david@lang.hm wrote:
> 
> a kernel compiled with this option would just drop-in to an older distro with
> zero impact. newer distros that have updated their userspace tools could
> compile with different options and have the firmware seperate.

The 'zero impact' is what doesn't make sense here.

You are supposed to be able to run ol distributions, yes.

But that doesn't mean that you can necessarily just plop things in the 
same way as you always did before.

For example, you have to rewrite your distro's initrd if you are using 
modules. You cannot just re-use the modules in the distro initrd. So doing 
a new kernel has _never_ been 'zero impact' in the sense that you could 
just switch vmlinux files around.

(Btw, I personally actually want my kernel to be _truly_ zero impact, but 
that also means that I don't use modules - because that way I really can 
avoid changing even the initrd image too. But that also already works)

Why is it suddenly so important that a kernel be 'zero impact' for that 
module case, when it's never been zero impact for that case before? You 
had to rewrite the initrd to begin with, but now you're not willing to do 
it again, just because you have to rewrite it slightly _differently_?

THAT is what I find so odd. The inability to accept just a slight change 
in kernel build.

But whatever. This really isn't worth it. The request_firmware() thing 
will clearly happen regardless, and as long as the backwards compat code 
is small and Jeff writes it, what do I care? Even if I think it looks 
largely pointless..

			Linus


