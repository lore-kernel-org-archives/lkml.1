Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbZEFWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbZEFWXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763738AbZEFWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:22:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763359AbZEFWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:21:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=K0JOaFQUASKXjiCsQ1IaavIg0qPM1ofMrO8Feot/eWlulMbteumNNp6G8H/BqF0By
	uZLZe0mvX2PzjYz4IIzBQ==
MIME-Version: 1.0
In-Reply-To: <20090506221319.GA11493@elte.hu>
References: <20090228030413.5B915FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	 <20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
	 <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
	 <20090506212913.GC4861@elte.hu>
	 <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com>
	 <20090506215450.GA9537@elte.hu>
	 <904b25810905061508n6d9cb8dbg71de5b1e0332ede7@mail.gmail.com>
	 <20090506221319.GA11493@elte.hu>
Date: Wed, 6 May 2009 15:21:51 -0700
Message-ID: <904b25810905061521v62b3ddd6l14deb614d203385a@mail.gmail.com>
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

On Wed, May 6, 2009 at 15:13, Ingo Molnar <mingo@elte.hu> wrote:
> doing a (per arch) bitmap of harmless syscalls and replacing the
> mode1_syscalls[] check with that in kernel/seccomp.c would be a
> pretty reasonable extension. (.config controllable perhaps, for
> old-style-seccomp)
>
> It would probably be faster than the current loop over
> mode1_syscalls[] as well.

This would be a great option to improve performance of our sandbox. I
can detect the availability of the new kernel API dynamically, and
then not intercept the bulk of the system calls. This would allow the
sandbox to work both with existing and with newer kernels.

We'll post a kernel patch for discussion in the next few days,


Markus
