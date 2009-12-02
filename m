Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZLBGU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZLBGU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZLBGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:20:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:50294 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZLBGU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:20:58 -0500
Message-ID: <4B160769.2060802@windriver.com>
Date: Wed, 02 Dec 2009 14:21:29 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>, mingo@redhat.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add --list option for listing	current
 probe events
References: <20091201002017.10235.76575.stgit@harusame> <tip-4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a@git.kernel.org> <4B15E913.1040105@windriver.com> <4B15F36F.5040304@redhat.com> <4B15FCAB.7000209@windriver.com> <20091202060655.GB5719@nowhere>
In-Reply-To: <20091202060655.GB5719@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 06:20:19.0108 (UTC) FILETIME=[85490E40:01CA7317]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Dec 02, 2009 at 01:35:39PM +0800, Wang Liming wrote:
>> Yes, my glibc is old so that "perf" can't be built. I'm using ubuntu 8.04.
>>
>> Thanks a lot.
> 
> 
> 
> What is your glibc version?
> %m appears to be supported since 2.7
I'm using ubuntu 8.04, and glibc version seems to be 2.7.

$dpkg -l |grep libc|less
ii  libc6                                      2.7-10ubuntu4 
                           GNU C Library: Shared libraries
ii  libc6-dev                                  2.7-10ubuntu4 
                           GNU C Library: Development Libraries and Header

$gcc -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v 
--enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr 
--enable-shared --with-system-zlib --libexecdir=/usr/lib 
--without-included-gettext --enable-threads=posix --enable-nls 
--with-gxx-include-dir=/usr/include/c++/4.2 --program-suffix=-4.2 
--enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc --enable-mpfr 
--enable-targets=all --enable-checking=release --build=i486-linux-gnu 
--host=i486-linux-gnu --target=i486-linux-gnu
Thread model: posix
gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu4)

> 
> But if possible we would like perf to be buildable on most
> boxes. May be should we use %a instead there.
I think so. We couldn't assume that all users use the latest glibc.

Liming Wang
> 
> odd gcc versions will whine because of the confusion with the %a for
> floating point things but that can be worked around with (float *) casts (sigh).
> Well, since we also have strict aliasing checks, we'll actually need:
> 
> scanf("%a", (float *)(void *)str);
> 
> We do that in util/trace-event-parse.c
> 
> 

