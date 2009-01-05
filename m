Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZAESO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZAESO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZAESOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:14:44 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:51431 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572AbZAESOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:14:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAAPcYUlMQWjN/2dsb2JhbACBbMwphXI
Date: Mon, 5 Jan 2009 13:09:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090105180933.GB10366@Krystal>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal> <20090102230116.GB5235@localhost> <20090102234254.GB29623@Krystal> <20090104041018.GB5198@localhost> <20090105160534.GA7708@Krystal> <20090105175750.GB5196@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090105175750.GB5196@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:07:42 up 4 days, 18:05,  2 users,  load average: 0.04, 0.08,
	0.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Mon, Jan 05, 2009 at 11:05:34AM -0500, Mathieu Desnoyers wrote:
> > Hopefully it does, especially when there are no side-effects. Can you
> > also try with -Os ?
> > 
> > Mathieu
> 
> Here's the disassembled code when using -Os. It seems it's optimised, as
> with -O2. My GCC's version is 4.3.2 (Gentoo Linux).
> 
> If you want to test yourself, the output was generated with 'objdump -d
> -S -a'.
> 
> What do you think?
> 
> static void print_that(unsigned long num)
> {
> 	printf("input << 5 == %lu\n", num);
>   40062d:	48 c1 e6 05          	shl    $0x5,%rsi
>   400631:	bf 5e 07 40 00       	mov    $0x40075e,%edi
>   400636:	31 c0                	xor    %eax,%eax
>   400638:	e8 6b fe ff ff       	callq  4004a8 <printf@plt>
> 	sscanf(argv[2], "%lu", &in);
> 
> 	call_do_something(in);
> 
> 	return 0;
> }
>   40063d:	5a                   	pop    %rdx
>   40063e:	59                   	pop    %rcx
>   40063f:	31 c0                	xor    %eax,%eax
>   400641:	5b                   	pop    %rbx
>   400642:	c3                   	retq   
> 
> 
> 	Eduard
> 

It looks good. Although I wonder if gcc will still optimize this in more
complicated functions. Just to be 100% sure, I would recommend testing
it in larger functions like schedule() in the kernel tree. But so far it
looks like it does not hurt much to leave a small supplementary operation
in the unlikely() branch.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
