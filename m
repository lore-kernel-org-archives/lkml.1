Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZFCOGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZFCOGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZFCOGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:06:04 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:45357 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZFCOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:06:03 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090601203845.B010DFC3C7@magilla.sf.frob.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090601161234.GA10486@redhat.com>
	 <20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	 <20090601171119.GA13970@redhat.com>
	 <20090601184608.6379440c@lxorguk.ukuu.org.uk>
	 <20090601182305.GA16372@redhat.com>
	 <20090601203845.B010DFC3C7@magilla.sf.frob.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Wed, 03 Jun 2009 10:05:57 -0400
Message-Id: <1244037957.7369.492.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 13:38 -0700, Roland McGrath wrote:
> 1. More core-dump signals.  e.g., it was already crashing and you hit ^\
>    or maybe just hit ^\ twice with a finger delay.  
> 2. Non-fatal signals (i.e. ones with handlers, stop signals).
> 3. Plain sig_fatal() non-core signals (e.g. SIGINT when not handled)
> 4. SIGKILL (an actual one from userland or oomkill, not group-exit)
> 
> #1 IMHO should not do anything at all.  
> You are asking for a core dump, it's already doing it.
> 
> #2 should not do anything at all.
> It's not really possible to suspend during the core dump, so unhandled,
> unblocked stop signals can't do anything either.
> 
> #4 IMHO should always stop everything immediately.
> That's what SIGKILL is for.  When userland generates a SIGKILL
> explicitly, that says the top priority is to be gone and cease
> consuming any resources ASAP.
> 
> #3 is the open question.  I don't feel strongly either way.

Thanks Roland.  This is a great summary and lends clarity to the
discussion.

Actually I'm quite happy with the above for #'s 1, 2, and 4.

I've already stated my preference that #3 should behave like #2, but
certainly people can disagree on this and I understand that some would
like it to behave as #4.  Best case is this can be configured or, at
least if it's documented clearly userspace applications can code
defensively by masking those signals (this has minor annoyances but...)

Unfortunately the discussion you and Oleg are having shows me how little
I know about this area of the kernel and what a bad idea it would be for
me to try to get this right on my own :-).  However, I'm happy to test
patches, comment on solutions, etc.
