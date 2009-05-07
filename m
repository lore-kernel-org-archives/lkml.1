Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZEGEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZEGEYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZEGEYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:24:00 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:50651 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbZEGEX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:23:59 -0400
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
From: Nicholas Miell <nmiell@comcast.net>
To: Markus Gutschke =?UTF-8?Q?=28=E9=A1=A7=E5=AD=9F=E5=8B=A4=29?= 
	<markus@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <904b25810905061521v62b3ddd6l14deb614d203385a@mail.gmail.com>
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
	 <904b25810905061521v62b3ddd6l14deb614d203385a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 May 2009 21:23:57 -0700
Message-Id: <1241670237.11500.7.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 15:21 -0700, Markus Gutschke (顧孟勤) wrote:
> On Wed, May 6, 2009 at 15:13, Ingo Molnar <mingo@elte.hu> wrote:
> > doing a (per arch) bitmap of harmless syscalls and replacing the
> > mode1_syscalls[] check with that in kernel/seccomp.c would be a
> > pretty reasonable extension. (.config controllable perhaps, for
> > old-style-seccomp)
> >
> > It would probably be faster than the current loop over
> > mode1_syscalls[] as well.
> 
> This would be a great option to improve performance of our sandbox. I
> can detect the availability of the new kernel API dynamically, and
> then not intercept the bulk of the system calls. This would allow the
> sandbox to work both with existing and with newer kernels.
> 
> We'll post a kernel patch for discussion in the next few days,
> 

I suspect the correct thing to do would be to leave seccomp mode 1 alone
and introduce a mode 2 with a less restricted set of system calls -- the
interface was designed to be extended in this way, after all.

-- 
Nicholas Miell <nmiell@comcast.net>

