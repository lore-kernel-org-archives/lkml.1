Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZB1Iqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZB1Iqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZB1Iqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:46:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:32432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZB1Iqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Y2cbtsp7Tss4yj3YNpD8iA7yjSUj86SdINOcdCDLyc5b86y20ch9z3eg90Spgzekpu
         LaCA7ZxEMXD/9ELT5vvmQVfChFTOF8L/m8JzOSjO5In45wCzxJFAb/Cue/nh9sJSbGAr
         LIwd49g/KDUDl2kpENBfSARvylNoYmOzTdlOo=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090228024424.D237CFC3DA@magilla.sf.frob.com>
References: <20090226133339.875832967@linutronix.de>
	 <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	 <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
	 <cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
	 <20090228024424.D237CFC3DA@magilla.sf.frob.com>
Date: Sat, 28 Feb 2009 21:46:35 +1300
Message-ID: <cfd18e0f0902280046k3171c97uaf9d984bd7894e82@mail.gmail.com>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux API <linux-api@vger.kernel.org>, drepper@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/09, Roland McGrath <roland@redhat.com> wrote:
>> With respect to the first point, it seems to me reasonably likely that
>> there would be use cases where the receiving thread wants to know the
>> thread ID of the sender -- especially when sender and receiver are in
>> the same process.
>
> But expecting si_pid to play that role is bizarre.

Oh -- I wasn't suggeting that si_pid do that task; I was instead
wondering if we needed an additional si_threadid field (or some such).

> It's never what any
> POSIX-like program would do, both since POSIX says si_pid is a process ID,
> and because there are no POSIX-like interfaces at all that use Linux TIDs
> to refer to threads.

(Nod.)

> Wanting this only seems plausible within one process.

We are in agreement.

> In that case, sender
> and recipient know they share memory.  The normal thing to do (and what
> POSIX applications will do) is to store that info somewhere pointed to by
> the sigval.

Good point.  That would be another of dealing with point I wondered
about, and probably better than my idea.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
