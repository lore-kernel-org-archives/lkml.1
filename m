Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbYB2Tt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbYB2Tt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbYB2TtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:49:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:15099 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbYB2TtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H/LDh0ILcp3fobzEe5mmazcI6meUzIUnjwDduwzN2U4DND1YGbeSwA7cFKvyVWXgybx/cm4vQ8WEqz7MuLRIZQKuIW2VmIUxXd7TnmmSDw1/OPdjlrxVaNrLDkpS4xqHWxaiAVJq4OFTv/qtCkAbIn2JKWuK0x2TqA3mSoPGVMM=
Message-ID: <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>
Date: Fri, 29 Feb 2008 20:49:16 +0100
From: "Michael Kerrisk" <michael.kerrisk@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, carlos@codesourcery.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, "Geoff Clare" <gwc@opengroup.org>
In-Reply-To: <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <1204305244.6243.111.camel@lappy>
	 <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
	 <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>
	 <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 7:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Fri, 29 Feb 2008, Michael Kerrisk wrote:
>  >
>  > My reading of POSIX.1 (and POSIX doesn't seem very explicit on this point), is
>  > that the limits on argv+environ and on stack are decoupled, since POSIX
>  > specifies RLIMIT_STACK and sysconf(_SC_ARG_MAX) and doesn't specify any
>  > relationship between the two.
>
>  I agree. And clearly there _are_ relationships and always have been, but
>  equally clearly they simply haven't been a big issue in practice, and
>  nobody really cares.

Do we know that for sure?

>  Usually, _SC_ARG_MAX is just so much smaller than RLIMIT_STACK that it
>  makes no possible difference.  Which I would actually argue we should just
>  continue with: just keep _SC_ARG_MAX a smallish, irrelevant constant.
>
>  We still have to have the compile-time ARG_MAX constant (as in *real*
>  constant - a #define) anyway, for traditional programs, and you might as
>  well make sysconf(_SC_ARG_MAX) always just match ARG_MAX.
>
>  It's not like there is likely a single user of _SC_ARG_MAX that cares.

In my initial reply, I pointed out one example where users *may* care:
NPTL uses RLIMIT_STACK to determine the size of per-thread stacks.  It
is conceivable that users might want to set RLIMIT_STACK < 512k, and
that would have the effect of lowering the amount of space for
argv+eviron below what the kernel has historically guaranteed.  That's
an ABI change, though it's unclear whether it would impact anyone in
practice.
