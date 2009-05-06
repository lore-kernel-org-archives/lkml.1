Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbZEFWVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbZEFWVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbZEFWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:08:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762901AbZEFWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:08:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=vlN1f6ehSs9cEwxJIcryrg1ZvM3s5THr1qvhnwCH9IuXHG8TjGtLY7bkTYDBI1BID
	joWhjdHK2OntygxxjM+gw==
MIME-Version: 1.0
In-Reply-To: <20090506215450.GA9537@elte.hu>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	 <20090228030413.5B915FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	 <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	 <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
	 <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
	 <20090506212913.GC4861@elte.hu>
	 <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com>
	 <20090506215450.GA9537@elte.hu>
Date: Wed, 6 May 2009 15:08:40 -0700
Message-ID: <904b25810905061508n6d9cb8dbg71de5b1e0332ede7@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
From: =?UTF-8?B?TWFya3VzIEd1dHNjaGtlICjpoaflrZ/li6Qp?= 
	<markus@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 14:54, Ingo Molnar <mingo@elte.hu> wrote:
> Which other system calls would you like to use? Futexes might be
> one, for fast synchronization primitives?

There are a large number of system calls that "normal" C/C++ code uses
quite frequently, and that are not security sensitive. A typical
example would be gettimeofday(). But there are other system calls,
where the sandbox would not really need to inspect arguments as the
call does not expose any exploitable interface.

It is currently awkward that in order to use seccomp we have to
intercept all system calls and provide alternative implementations for
them; whereas we really only care about a comparatively small number
of security critical operations that we need to restrict.

Also, any redirected system call ends up incurring at least two
context switches, which is needlessly expensive for the large number
of trivial system calls. We are quite happy that read() and write(),
which are quite important to us, do not incur this penalty.


Markus
