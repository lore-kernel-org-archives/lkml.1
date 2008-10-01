Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYJAO6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYJAO6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYJAO6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:58:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:47015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYJAO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ws/48QXDmBrnepi6nWwaF+OMXUEIq47DLxpjrtir+S6axtrbr4l+ci3njbh6k7veK1
         M2Tfe9/2NskS8USj/D1pGCdLgtlRYAk1Aem1MylvGXbYD/j8TaYvVcvjf6Fa78UWmH9m
         A4kKEFMGTaEci17T/KEK61OWfhI0NXf3SFBGg=
Message-ID: <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e@mail.gmail.com>
Date: Wed, 1 Oct 2008 16:57:58 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Roland McGrath" <roland@redhat.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       linux-api@vger.kernel.org
In-Reply-To: <20081001095204.343984413@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001095204.343984413@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=linux-api@vger.kernel.org]

On Wed, Oct 1, 2008 at 12:01 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Changes vs. V1: compat_sys_rt_sigqueueinfo implemented. Thanks Roland !
>
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.

This is an excellent candidate for CCing to the new linux-api@vger
(http://thread.gmane.org/gmane.linux.ltp/5658/), since it is an API
change.

> Find below the raw documentation.

Thanks -- I'll work that up into a man page when this gets closer to release.

Cheers,

Michael

> ----
>
> NAME
>       rt_tgsigqueueinfo - Send signal information to a signal to a thread
>
> SYNOPSIS
>       long sys_rt_tgsigqueueinfo (int tgid, int tid, int sig, siginfo_t *uinfo);
>
> DESCRIPTION
>
>       rt_tgsigqueueinfo sends signal sig information uinfo to the
>       thread with the thread ID tid in the thread group tgid.  (By
>       contrast, rt_sigqueueinfo(2) can only be used to send a signal
>       info to a process (i.e., thread group) as a whole, and the
>       signal will be delivered to an arbitrary thread within that
>       process.)
>
> RETURN VALUE
>
>       rt_tgsigqueueinfo returns 0 on success; otherwise,
>       rt_sigqueueinfo returns one of the errors listed in the
>       "Errors" section.
>
> ERRORS
>       -EFAULT
>              An invalid value for uinfo was specified.
>
>       -EINVAL
>              An invalid TID, TGID or signal was specified.
>
>       -EPERM
>              Permission denied.  For the required permissions,
>              see rt_sigqueueinfo(2).
>
>       -ESRCH
>              No process with the specified thread ID and thread group
>              ID exists.
>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
