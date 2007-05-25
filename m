Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXEYFL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXEYFL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXEYFLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:11:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42357 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbXEYFLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:11:52 -0400
Date: Fri, 25 May 2007 07:12:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Romano Giannetti <romano.giannetti@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69] -stablereview)
Message-ID: <20070525051245.GA4958@uranus.ravnborg.org>
References: <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost> <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org> <1180037649.15241.6.camel@localhost> <20070524140154.c8e93d69.akpm@linux-foundation.org> <20070524211237.GC1372@uranus.ravnborg.org> <20070524142126.88e89900.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524142126.88e89900.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 02:21:26PM -0700, Andrew Morton wrote:
> 
> It's not a matter of when it's evaluated.  The user is supposed to be
> able to set EXTRA_CFLAGS on the command-line, yes?  If they do that then
> the "=" in there will rub out their efforts.  The makefiles should be
> appending new things to EXTRA_CFLAGS, rather than doing a replacement?

There is no way to specify additional CFLAGS on the commandline today.
For sparse we took the shorthand CF so you can do:

make C=2 CF=-warn-bitwise

But we have no such thing for CFLAGS.
If there is a real need I can cook up something.
But frankly I have alway edited top-level Makefile and be doen with it.

I will fix it so Kbuild do not barf out if you set EXTRA_* on the commandline
but silently ignore it instead.

	Sam
