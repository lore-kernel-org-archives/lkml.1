Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYGOXob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYGOXob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYGOXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:44:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYGOXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:44:21 -0400
Date: Tue, 15 Jul 2008 16:42:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
 <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, david@lang.hm wrote:
>
> becouse the tools that wrote the initrd already put the modules in. I don't
> maintain those tools, they came with the distro. we're just asking to not
> require those tools to be updated immediatly.

But mkinitrd (which is the _only_ thing that people tend to use to write 
initrd's - is there even anything else) has already been doing this for 
years, as has been pointed out several times.

This is why I harped on the fact that you already rebuilt your initrd 
image.

So this really isn't a "updated immediately" issue, afaik. Googling for 

	mkinitrd MODULE_FIRMWARE

shows a patch from two years ago as the #1 hit in order to make the 
aic94xx driver work.

Loking down a bit, there's a hotplug discussion from early 2005 (gmane 
says "3 years, 20 weeks, 3 days, 6 hours and 39 minutes ago" in the 
header).

Quite frankly, if it's still a problem, there's simply something _wrong_ 
with the distribution. And yeah, maybe people need to update their kernel 
building tools.

I already pointed out how the kernel development team quite often says "we 
will no longer build with gcc-.xyz because it's too old and buggy". The 
build tools requirements are simply *different* from the runtime tools.

If it's literally just an issue of an mkinitrd that is too damn old, why 
don't we just make that test at kernel build time. *EXACTLY* the same way 
we test for compilers that are too old, and refuse to build with them?

(And no, I have no idea which version we should test for. In fact, 
mkinitrd seems to be singularly hard to test versions for, in that it 
seems to want the user to be root even just to give the version output. 
Ooh).

				Linus
