Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbXLUO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbXLUO5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXLUO5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:57:06 -0500
Received: from saeurebad.de ([85.214.36.134]:49951 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbXLUO5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:57:04 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: 2.6.24-rc5-git7: Reported regressions from 2.6.23
References: <200712210212.02666.rjw@sisk.pl> <87d4t05f5a.fsf@saeurebad.de>
	<476BC71A.40806@msgid.tls.msk.ru>
Date: Fri, 21 Dec 2007 15:56:58 +0100
In-Reply-To: <476BC71A.40806@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Fri, 21 Dec 2007 17:00:58 +0300")
Message-ID: <878x3o5c5h.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Michael Tokarev <mjt@tls.msk.ru> writes:

> By the way, is there any real need to specify default governor at
> a compile time in the first place?  Performance governor (which was
> the only default so far) is a very simple one (not large to consider
> its size effects for embedded systems for example), and switching
> governors at run time is trivial as well.  What's the motivation
> behind this new config option?

I think it is just convenient.  If you never use the performance
governor, there is no need to compile it.  I have no need for an init
script that changes the governor on runtime, too.  I just say, use this
and nothing else, ever.  Don't know if this convenience is worth the
trouble, though ;)

>> This migrates all governors from module_init() to fs_initcall() when
>> being the default, as was already done in cpufreq_performance when it
>> was the only possible choice.
>
> Oh well.  Which leads to more surprises in the future, I think...

It appears a bit hackish.  I would be interested in a cleaner way to
force an earlier call to a module's init function.

	Hannes
