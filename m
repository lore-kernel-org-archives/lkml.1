Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXCEQuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXCEQuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXCEQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:50:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:19541 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXCEQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:50:07 -0500
Date: Mon, 5 Mar 2007 08:47:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "FN" <zzzz444@ml1.net>
Cc: "Oleg Verych" <olecom@flower.upol.cz>, linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
Message-Id: <20070305084727.102b51f5.randy.dunlap@oracle.com>
In-Reply-To: <1173102794.12256.1177759349@webmail.messagingengine.com>
References: <1172855662.23830.1177403935@webmail.messagingengine.com>
	<E1HNyYT-00086z-27@flower>
	<1173102794.12256.1177759349@webmail.messagingengine.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2007 05:53:14 -0800 FN wrote:

> That's not for you to decide.
> Just pass down all variables that may be relevant to my module builds 
> and let me take it from there, for example
> chdir $(M)
> $(MYMAKE) CC="..." LD="..." AR="..." CFLAGS="..." MODFLAGS="..."
> INCL="..."
>           WHATHAVE_YOU="whatever"  modules
> 
> Currently I face the following situation -- I try to build 2 drivers
> from the same Makefile
> -----------
> CWD := $(shell pwd)
> obj-m := driver1.o driver2.o
> driver1-y := d1/d2/d3/f1.o d1/d2/f2.o
> driver2-y := d1/d5/file1.o d1/d6/file2.o
> # ill conceived kbuild framework doesn't allow me to reduce granularity
> # of EXTRA_FLAGS
> $(addprefix $(CWD)/,d1/d2/d3/f1.o d1/d5/file1.o: EXTRA_CFLAGS :=
> -DMASK=0x123
> $(addprefix $(CWD)/,d1/d2/f2.o d1/d6/file2.o) : EXTRA_CFLAGS :=
> -DMASK=0x456
> # fine grained scope for EXTRA_CFLAGS (supported by gnu make) doesn't
> work
> ----------
> There are 2 problems here
> 1) kbuild is forcing me to declare EXTRA_CFLAGS in global scope and 
>    I can't build my drivers properly because the MASKs are incompatible. 
> 2) assuming that modules are buildable, if I do "make clean" there is
> leftover
>    junk in all of these places d1/d2/d3 d1/d5 d1/d2 d1/d6.
>    There is a danger associated with that junk (or state), dependency
>    generation
>    may be broken which it provably is in some cases (remember -Iinc_dir1
>    -Iinc_dir2
>    vs. -Iinc_dir2 -Iinc_dir1 example I gave earlier) and I can't rely on
>    it.
>    So then I need to be able to clean all, but the "clean:" target can't
>    clean
>    inexpensively in multiple directorie, i.e. must do recursive
>    traversal to clean.
> 
> No, you can't send me off to some little kbuild mailing list.
> I've raised concerns that probably affects hundreds of module builders.
> kbuild works well only in the simplest of build scenarios but doesn't
> scale and that's a deficiency that should be urgently addressed.
> The leadership of the linux kernel is going to have to make
> a decision and possibly hire a competent contractor to fix these
> problems.
> Are you guys perfectionists or what?

Not at all.

I think you'll need to convince/show us that there is a real
problem that cannot be solved by current Kbuild.

E.g., instead of building 2 drivers from the same Makefile
where you cannot reduce granularity of EXTRA_FLAGS, can it be done
with 2 makefiles?  and if not, why not?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
