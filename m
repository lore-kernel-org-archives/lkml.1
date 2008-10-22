Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYJVI7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYJVI7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYJVI6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:58:37 -0400
Received: from bytemail.bytemark.co.uk ([80.68.81.165]:50308 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYJVI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:58:36 -0400
Message-ID: <48FEEB1E.1030809@bytemark.co.uk>
Date: Wed, 22 Oct 2008 09:58:06 +0100
From: Alex Howells <alex@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Greg KH <greg@kroah.com>, Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk> <20081020202147.GA20788@kroah.com>            <48FE32E2.5000601@bytemark.co.uk> <33098.1224636084@turing-police.cc.vt.edu>
In-Reply-To: <33098.1224636084@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=B188A23A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Valdis

>> Requirements for me to put a kernel on a given server would be:
> 
>>     *  supports the hardware
> The problem is that "supports" is often a fuzzy jello-like substance you
> try to nail to a tree.  You mention the R8169 and e1000 drivers - if they
> bring the device up, but have issues under corner cases, is that "supports"
> or not?

Oh agreed, this is all very "use case" specific.  I'm making all of the
following statements based on the specific hardware we use, and assuming
'stability' based on the kernel/hardware passing a number of tests.

>>     *  no security holes [in options I enable]
> Similarly for "no security holes".  At *BEST*, you'll get "no *known* *major*
> security holes", unless you feel like auditing the entire source tree.  There's
> a whole slew of bugs that we can't even agree if they *are* security bugs or
> just plain bugs - see Linus's rant on the subject a few months back.

Agreed. No *known* *major* security holes is fine here.

>>     *  works reliably, under load/stress.
> And you win the trifecta - I don't think we've *ever* shipped a Linux kernel
> that worked reliably under the proper "beat on the scheduler/VM corner case"
> load/stress testing.  Again, the best you can hope for is "doesn't fall over
> under non-pathological non-corner-case loads when sufficient resources are
> available so the kernel has a fighting chance".  Doing 'make -j100' on a
> single Core2 Duo is gonna be painful, no matter what.

Well the typical tests outlined above are:

    *  random size file creation/deletion, lots of files
    *  memory allocation, and freeing up again
    *  stressing the CPU a bit with one process, then
       forking 25-50 processes to (trivially) test scheduler
    *  testing network I/O by rapidly/concurrently fetching
       many small files via HTTP, and a few large ones.

The end goal is simply to get a server which doesn't crash under
"normal" operating conditions.  The bugs I referred to in
e1000/forcedeth and r8169 either stop it PXE booting (a requirement for
our environment!) or can *easily* be made to oops / stop working.

Alex

