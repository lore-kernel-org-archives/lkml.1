Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZHDLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZHDLXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZHDLXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:23:21 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63986 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbZHDLXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oUp7rzDoOuG7VGnmyoqjzALi10F4EmOHD4WavQ/IbeBzDzGAFmVgCFxLYEpBfgM2Xw
         7vwtoaBK8OfELo2+DMU6vy35FnG7Hgr5XNjqhshtO6T75kczVR1MfKpcyTrHmQKDtEHG
         kuvCG/b6UCE33ZiyR0C6kM9zCvE+rw8pjmd6U=
MIME-Version: 1.0
In-Reply-To: <1249382332.7924.192.camel@twins>
References: <20090729192814.GT4148@kernel.dk> <20090802184148.GB17241@elte.hu> 
	<20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> 
	<20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net> 
	<20090803015430.GG25334@ghostprotocols.net> <20090804092540.GA29778@elte.hu> 
	<87d3b2040908040332i87bf211y8fc782d67b3157a3@mail.gmail.com> 
	<1249382332.7924.192.camel@twins>
From: Frederic Riss <frederic.riss@gmail.com>
Date: Tue, 4 Aug 2009 13:23:00 +0200
Message-ID: <87d3b2040908040423n32eddbefs93f3146b836f8503@mail.gmail.com>
Subject: Re: [PATCH] basic perf support for sparc
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/4 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Tue, 2009-08-04 at 12:32 +0200, Frederic Riss wrote:
>> If all you want is C++ symbols demangling, why not just look for the
>> c++filt binary on the system? It accepts mangled names on its stdin
>> and outputs the demangled name on stdout.  You can keep it running in
>> the background, and communicate through pipes. Of course it's not as
>> effective as a library call, but I guess that it'll be much more
>> generic and also much more likely to be found on a developer's system
>> than a libbfd shared library.
>
> Oddly enough c++filt uses libbfd :-)
>
> $ ldd `which c++filt`
>        linux-gate.so.1 =>  (0xffffe000)
>        libbfd-2.19.1.so => /usr/lib/libbfd-2.19.1.so (0xf7de9000)
>        libz.so.1 => /lib/libz.so.1 (0xf7dd3000)
>        libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xf7c6f000)
>        /lib/ld-linux.so.2 (0xf7ef9000)

Hehe... It depends how distro build it. IIRC, the default binutils
configure links statically, but I might be wrong. Anyway, this
approach still has the advantage that the binary is called 'c++filt'
and not c++filt-2.19.1-fc11 :-)

Fred
