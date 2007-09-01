Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXIAWJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXIAWJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbXIAWI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:08:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbXIAWI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:08:58 -0400
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:08:57 +0200
In-Reply-To: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
Message-ID: <p733axyxcli.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Mike Frysinger" <vapier.adi@gmail.com> writes:

> is there any sort of standard for testing and integration into
> mainline ?  

Everybody does their own.

> in the Blackfin world, we've been developing little
> external kernel modules and adding them to our own testsuite, but
> often times these things are not Blackfin specific.  case in point,
> we're integrating a string testsuite to make sure all of the fun str*
> and mem* functions are sane and operate as they expected, but rather
> than having just Blackfin benefit here, i'd like to see this pushed
> upstream ...

I would like to see this too. I wrote a couple of unit tests
during x86-64 development too and they would be handy
to have in a central place.

The SUSE kernel also has a crasher module that exercises the
allocators and is pretty useful to stress code in general.

Disadvantage is that test code tends to be hackish and ugly
and very specialized and will probably not pass standard review procedures.

Also the rt people seem to have pushed a couple of tests in already, 
but I always hated it that they're in the standard directories.
RCU also has, in fact they added a "eat all my CPU in tests"
CONFIG option. Just making that dependent on a CONFIG_UNIT_TESTS
would be a good change in itself. And then there are the slab
failure inducers of course.

BTW string functions are best tested in user space. That's
a relatively bad example.

-Andi
