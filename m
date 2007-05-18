Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXERXHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXERXHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXERXHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:07:00 -0400
Received: from www.osadl.org ([213.239.205.134]:48586 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755626AbXERXG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:06:59 -0400
Subject: Re: [Bug 8501] udivdi3  absence with gcc-4.3.0 on kernels
	2.6.20.11 & 2.6.22.-rc1
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, malitzke@metronets.com,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
References: <200705181941.l4IJfOtf018049@fire-2.osdl.org>
	 <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 19 May 2007 01:12:23 +0200
Message-Id: <1179529943.12981.106.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 15:29 -0700, Andrew Morton wrote:
> We use the above idiom in several places.  A suitable fix might be to hunt
> down those various sites and then make them call a helper function which
> does
> 
> 	if (unlikely(ns >= NSEC_PER_SEC)) {
> 		do_div(...)
> 	}
> 
> (Better would be to inline the comparison and to uninline the do_div(),
> if it's a 32-bit arch.  Doing all this in a backportable fashion may
> prove tricky)

A suitable fix would be to slap the gcc maintainers with a large trout
to fix this nonsense. At least they should provide a command line option
to prevent this extra intelligent optimization.

	tglx


