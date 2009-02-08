Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZBHVaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZBHVaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZBHV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:29:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:7908 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBHV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Jhjm2oWxwOPciIZVt1GBniR3TTe8z6yVpkdrM+cQTjrHqLc3rvAA9uzT7557fl9h1x
         a4IgXLkcoOwl9bs0nKsKOqpw6qJmq0b0kRQB4k5hbwTt9KJI+32FpzzRi2IScTyybCgC
         tqjx2Xa+3oclebwiQsx4Pz/s4papoSxDqfyZk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>
	 <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
	 <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
Date: Mon, 9 Feb 2009 10:29:51 +1300
Message-ID: <cfd18e0f0902081329j4b18c4f2g91269d3209f1932d@mail.gmail.com>
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and 
	CLOCK_MONOTONIC?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>        BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
>        BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
>
> -       if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
> +       if ((flags & ~TFD_FLAGS_SET) ||
> +           invalid_clockid(clockid))
>                return -EINVAL;

Oh!  Does this mean that in 2.6.2[789] it wasn't possible to use
TFD_TIMER_ABSTIME?

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
