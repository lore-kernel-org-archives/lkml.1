Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbZHDKcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbZHDKcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbZHDKcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:32:47 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40787 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbZHDKcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eT7kvx45wOEC+JKW54E+8DNDfAiW4Af8/ZdVLDZrEQ1IZ8YKqvZWfzV8FBxBgzaqIB
         gha58oChUiFFdcOyNQiFj7m8hyg2qWdWtRNsuxFHQSFc/UUXUMN6gp8ZnBI+GxfFj0GM
         UPn/EuGJlTDYT6iF7lKZLPZthX3rGg5nKCkt8=
MIME-Version: 1.0
In-Reply-To: <20090804092540.GA29778@elte.hu>
References: <20090729192814.GT4148@kernel.dk> <20090801082048.GX12579@kernel.dk> 
	<20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> 
	<20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> 
	<20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net> 
	<20090803015430.GG25334@ghostprotocols.net> <20090804092540.GA29778@elte.hu>
From: Frederic Riss <frederic.riss@gmail.com>
Date: Tue, 4 Aug 2009 12:32:26 +0200
Message-ID: <87d3b2040908040332i87bf211y8fc782d67b3157a3@mail.gmail.com>
Subject: Re: [PATCH] basic perf support for sparc
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/4 Ingo Molnar <mingo@elte.hu>:
>
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
>
>> +static void load_perf_bfd_demangle(void)
>> +{
>> +     void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);
>
> Hm, this does not look like a very generic solution. Is there some
> way to do a library search to figure out the name? I guess a glob
> match on /usr/lib/libbfd*.so?

If all you want is C++ symbols demangling, why not just look for the
c++filt binary on the system? It accepts mangled names on its stdin
and outputs the demangled name on stdout.  You can keep it running in
the background, and communicate through pipes. Of course it's not as
effective as a library call, but I guess that it'll be much more
generic and also much more likely to be found on a developer's system
than a libbfd shared library.

Fred.
