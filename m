Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbYI2GSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbYI2GSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYI2GSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:18:05 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17750 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYI2GSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=O3ebYuGqnP45jT5rcQdlAj4WCu0WKM6XecJxfkxel66rZzD/M5BSVZChPHydOh43dc
         Jjep2wtas4UTv+KJ0EVbMUWrgzFSRoRtojptnDzLldUHH4u/knQ1mQkCDqBdDicecClU
         ec36quRw2oHPS0SJw23SzLIFITH2mXnTLQIAo=
Message-ID: <4b6fba110809282318p3d2f6a6dp5529958b94afa7b@mail.gmail.com>
Date: Mon, 29 Sep 2008 02:18:00 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: linux object file containing all kernel symbols and suitable for userspace linking?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080928140633.GA4956@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4b6fba110809271957t78d7c0c6m97b2b6c1386f7700@mail.gmail.com>
	 <4httd4pt37d715nqfvge2fau7nahbq6u3a@4ax.com>
	 <4b6fba110809280022x4e10a068s479dd3d2fd67e9ba@mail.gmail.com>
	 <20080928140633.GA4956@c2.user-mode-linux.org>
X-Google-Sender-Auth: eca529d3dda1866f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These are provided by the linker script.

Ok, I took a look at both vmlinux_32.lds.S and uml.lds.S (I'm assuming
these are the linker scripts).  I also took a look at vmlinux.  I
didn't realize at first that vmlinux actually has some symbols in it.
I linked vmlinux to my programs using gcc and it compiled, but I got a
segmentation fault when I ran it.  What is the appropriate binary
format to use to output the kernel binary so it won't segfault in
userspace?  Ideally, I would like to add another target, say
vmlinux-user, that would output the kernel with all the same symbols
that vmlinux contains, but with a binary format suitable for userspace
linkage.  It looks from uml.lds.S that you don't use the default ELF
output format for UML.  Why is this?

I guess I probably need to write another architecture specific *.lds.S
file called something like vmlinux-user.lds.S and add a few lines to
the Makefile in the root directory to achieve what I am trying to do,
but I would like to find as general a solution as I can so that maybe
other architectures and other people can use the same solution for
doing kernel code unit tests without replicating a lot of code.

By the way, I noticed that you only have a single uml.lds.S file, and
consequently UML probably either only works on x86 (and x86-64), or
uses the same binary layout on all platforms.  I couldn't find
anywhere explicitly where you say UML only runs on x86, but just to
clarify, UML is x86 specific, right?

Daniel


> Work email - jdike at linux dot intel dot com

Sorry, I misread the {addtoit,linux.intel} as {addtoit,linux,intel} in
arch/um/Makefile.
