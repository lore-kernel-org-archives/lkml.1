Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXIVStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXIVStT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:49:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:25409 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXIVStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jK/W4A900b0a4Tu3vuo119XZPXAOmbkRx9rErpvNnVAQEoh2+kmVQE8ITdGJu22POMJxULyIxBF6EXPzJ0muKEtzZ3pLNMcY/TtfFINu+Euz81U7VO2RjDTOJ4fbD8FWa41jCQILhZSe6nqY2oB93S3OEi1HuESYujbMQS3yLh8=
Message-ID: <517f3f820709221149x761abea8vf7e3529f0f3ddc64@mail.gmail.com>
Date: Sat, 22 Sep 2007 20:49:09 +0200
From: "Michael Kerrisk" <mtk.linux.lists@gmail.com>
To: "John Z. Bohach" <jzb2@aexorsyst.com>
Subject: Re: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN IF the SIGNAL was caught by the child?
Cc: linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
In-Reply-To: <200709221122.09523.jzb2@aexorsyst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221122.09523.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

> It is unclear from the various documentions in the kernel and glibc what
> the proper behaviour should be for the case when a child process
> catches a SIGNAL (say for instance, SIGTERM), and then calls exit()
> from within its caught SIGNAL handler.
>
> Since the exit() will cause a SIGCHLD to the parent, and the parent
> (let's say) has a SIGCHLD sigaction (SA_SIGINFO sa_flags set), should
> the parent's WIFSIGNALED(siginfo->si_status) be true?
>
> To recap, the WIFSIGNALED section of the waitpid() manpage says:
>
> WIFSIGNALED(status)
>    returns true if the child process was terminated by a signal.
>
> So the dilemna:  the child caught the signal, so it wasn't terminated by
> a signal, but rather its signal handler (let's say) called exit.
>
> Furthermore:
>
> WTERMSIG(status)
>    returns the number of the signal that caused the  child  process
>    to  terminate. This macro should only be employed if WIFSIGNALED
>    returned true.
>
> Observered behaviour with 2.6.20.6 is that is WIFSIGNALED(status)
> returns true (possibly incorrect), and furthermore, WTERMSIG(status)
> returns the exit(VALUE) VALUE from the child's exit() call, and not the
> SIGNAL (let's say SIGTERM that the child caught).  This may be correct,
> since the siginfo_t * si_status member is:
>
> int      si_status; /* Exit value or signal */
>
> but there's no clarity on which:  exit value or signal.  Since the child
> exited, I'm likely to assume exit status, which is current observed
> behaviour, but then, WIFSIGNALED(status) should be FALSE, which its not
> (observed with 2.6.20.6).
>
> So could someone clarify the kernel's intent?
>
> I can provide a short C program to illustrate above behaviour, if
> needed.  It also could be that I'm just misinterpreting the intent,
> which is why I'm not calling this a bug, despite a possible
> inconsistency in behaviour.

If the child terminated by calling exit(), regardless of whether it
was done from inside a signal handler, then WIFEXITED() should test
true, but WIFSIGNALED() will not.  If you are seeing otherwise, then
show a *short* program that demonstrates the behavior.  (But it seems
unlikely that there would be a kernel bug on this point, so do check
your program carefully!)

Cheers,

Michael
