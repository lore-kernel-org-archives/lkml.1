Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbZAGWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbZAGWNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZAGWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:13:21 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:2475 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZAGWNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:13:20 -0500
Date: Wed, 7 Jan 2009 16:13:12 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090107221312.GB950819@hiwaay.net>
References: <4962BB13.7060304@davidnewall.com> <20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk> <496479EA.1020207@davidnewall.com> <20090107095419.70b78dc7@lxorguk.ukuu.org.uk> <49648163.9060007@davidnewall.com> <20090107105201.054c011f@lxorguk.ukuu.org.uk> <4964B20B.4030406@davidnewall.com> <20090107141025.143158b7@lxorguk.ukuu.org.uk> <4964BDD2.3000803@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964BDD2.3000803@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> I went back to the start of the thread.  Chris posted a stack trace
> showing "#15 0xffffffff8104ec16 in ntp_leap_second (timer=<value
> optimized out>) at kernel/time/ntp.c:143".  That would be kernel code to
> process leap seconds from NTP broadcasts, I think.  That code needs to
> be removed.

Well, the code is to process when the kernel is told about leap seconds
(it doesn't have to be NTP, you can do it with adjtimex, which is what I
did to track down the problem).

But why should it be removed?  Why change Linux to be incompatible with
POSIX and other Unix systems?  This could create real problems with
things like network file systems for example.  Even trying to get
interoperation between UTC-Linux and TAI-Linux would be a PITA.

There was a bug, there is a patch, it should be fixed.  There's no
reason to reinvent the wheel just because there was a bug.

Looking at comments, there was another bug related to the same
xtime_lock/printk issue but not in leap second related code; it was
trying to print a message about changing clock sources.  Should we now
re-architect all of that as well?

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
