Return-Path: <linux-kernel-owner+w=401wt.eu-S1763205AbXLUOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205AbXLUOBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXLUOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:01:07 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21741 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbXLUOBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:01:06 -0500
Message-ID: <476BC71A.40806@msgid.tls.msk.ru>
Date: Fri, 21 Dec 2007 17:00:58 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: 2.6.24-rc5-git7: Reported regressions from 2.6.23
References: <200712210212.02666.rjw@sisk.pl> <87d4t05f5a.fsf@saeurebad.de>
In-Reply-To: <87d4t05f5a.fsf@saeurebad.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
[]
> I still have a bug with cpufreq when using ondemand governor as default.
> 
> The performance governor, which has been the essential default until
> 1c2562459faedc35927546cfa5273ec6c2884cce,  was initialized with
> fs_initcall() instead of module_init() to make sure the driver is up and
> running when the bootcode (speedstep_init in my case) calls into it.
> 
> Since the above mentioned commit, other governors can also be chosen to
> be the default but they are not correctly initialized before first use
> then.

By the way, is there any real need to specify default governor at
a compile time in the first place?  Performance governor (which was
the only default so far) is a very simple one (not large to consider
its size effects for embedded systems for example), and switching
governors at run time is trivial as well.  What's the motivation
behind this new config option?

[]
> This migrates all governors from module_init() to fs_initcall() when
> being the default, as was already done in cpufreq_performance when it
> was the only possible choice.

Oh well.  Which leads to more surprises in the future, I think...

Thanks.

/mjt
