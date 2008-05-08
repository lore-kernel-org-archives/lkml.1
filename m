Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYEHMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYEHMei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYEHMe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:34:29 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:44231 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYEHMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:34:27 -0400
Message-ID: <4822F39A.90608@keyaccess.nl>
Date: Thu, 08 May 2008 14:35:38 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Fabio De Francesco <fabiomdf@alice.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is
 less than 896MB?
References: <200804301702.06019.fabiomdf@alice.it> <481DCA14.9030302@keyaccess.nl> <200805080948.19914.fabiomdf@alice.it>
In-Reply-To: <200805080948.19914.fabiomdf@alice.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 09:48, Fabio De Francesco wrote:

>>> I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with

>> Others have already answered as well so this just as by the way and just in 
>> case... why are you running a 32-bit kernel on it?

> It's only because when I got the box I had to make it run as soon as
> possible, sooner than I'd had time to investigate which possible
> benefits I would have had from running a 64bit distribution.
> 
> Further, since I had to install a Gentoo GNU/Linux distribution by
> "emerging" from a chroot(-ed) environment inside an Ubuntu 32bit one
> (it takes too long to explain why), I supposed I couldn't do that for
> installing a 64bit Gentoo. Still today I don't know whether or not I
> assumed that wrongly.
> 
> Today I would switch to a 64bit Gentoo but, first I don't know how to
> do that in a secure and fast way, second I still don't know if it is
> worth the job...
> 
> Could you please summarize which benefits I would gain from that?

Not directly as it's quite dependent on your use of the box but generally
I'd quite definitely use 64-bit on that. Running a 32-bit OS on a 64-bit
capable 4G machine today is sort of like running MS-DOS on a 64 MB PC a
decade ago (or like putting a Fiat 500 engine in an Alfa Romeo if you
prefer car analogies...).

32-bit architectures have a 32-bit address space but this does not
translate directly into being able to cope with 4G of memory, and
certainly not well. You already remarked on the 896 MB lowmem; note
that it might've been called 'sanemem' just as well really. If you
want to address more than that 896M you have to resort to highmem or
adjust the traditional UNIX 3/1 address space split down. Worse still
in your situation -- not just more than 896M but 4G -- the system can
not even address all of your memory _at all_ without hardware hacks
such as PAE due to it also needing a bit of the physical address
space for things such as hardware mappings. In any case, not any
single application can make use of all of it on 32-bit.

Basically, 32-bit stopped being a good idea once physical memory
below 1G (or 768M) stopped being a good idea. If you'd experience
much practical downside depends on use. Highmem, lots of it, is
slower but you might not care if you don't use all that memory
intensively, nor about the application addressing limit, and with 4G
you'd not yet be running into situations that the amount of lowmem
available gets to be too little to support the amount of highmem ...

... but running a 32-bit on that machine while it's capable of 64-bit
is still Just Wrong(TM). It works, but it's stapling kludges onto
kludges.

Rene.
