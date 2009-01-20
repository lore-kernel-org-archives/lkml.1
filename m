Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbZATRnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbZATRnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZATRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:43:08 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:11434 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZATRnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=krCnMYyP4jcmWpyyUoh/PHtQJbufIgfTbAanBSGwgFsOPEclGiTosBttNtD6aP+O5D
         f7PRvwXh3GQEWsNPrTLrM38teCSq7VqrpLLAC2p2v20zIHVRob/i+nDvXcKbI2A2EJuh
         mCKw0s7MA+a3gL7ehcSZVbkrnzcafpOpfbKWo=
Message-ID: <f058a9c30901200943p4f453806sc2448893584e0ce3@mail.gmail.com>
Date: Tue, 20 Jan 2009 17:43:02 +0000
From: "Miguel F Mascarenhas Sousa Filipe" <miguel.filipe@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Cc: "Nick Piggin" <npiggin@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
In-Reply-To: <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
	 <20090112005228.GS26290@one.firstfloor.org>
	 <496B86B5.3090707@t-online.de>
	 <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain>
	 <20090112193201.GA23848@one.firstfloor.org>
	 <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain>
	 <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu>
	 <20090119062212.GC22584@wotan.suse.de>
	 <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 9:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 19 Jan 2009, Nick Piggin wrote:
>>
>> I want to know what is the problem with the restrict keyword?
>> I'm sure I've read Linus ranting about how bad it is in the
>> past...
>
> No, I don't think I've ranted about 'restrict'. I think it's a reasonable
> solution for performance-critical code, and unlike the whole type-aliasing
> model, it actually works for the _sane_ cases (ie doing some operation
> over two arrays of the same type, and letting the compiler know that it
> can access the arrays without fearing that writing to one would affect
> reading from the other).
>
> The problem with 'restrict' is that almost nobody uses it, and it does
> obviously require programmer input rather than the compiler doing it
> automatically. But it should work well as a way to get Fortran-like
> performance from HPC workloads written in C - which is where most of the
> people are who really want the alias analysis.

while working in my college thesis, a fortran HPC workload (10k lines
of fortran), converted to C resulted in performance speedups. this was
with gcc 3.4.
A simple f2c conversion + adaptations, resulted in a considerable
speedup. (20% IIRC).
The conversion was not done by performance reasons, the extra
performance was simply a unexpected, but quite nice outcome.
Just to let you guys know, that even with gcc3.4, gcc of C code ran
faster than gfortran of the equiv. fortran code.


... pushing the optimization engine further (-march tunning and -O3)
resulted in bad data.
But I can't swear by the correctness of some of the computations with
REAL's made in the original fortran code.



>
>> it seems like a nice opt-in thing that can be used where the aliases are
>> verified and the code is particularly performance critical...
>
> Yes. I think we could use it in the kernel, although I'm not sure how many
> cases we would ever find where we really care.
>
>                        Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Miguel Sousa Filipe
