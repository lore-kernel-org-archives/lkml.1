Return-Path: <linux-kernel-owner+w=401wt.eu-S935579AbXEVWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579AbXEVWTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEVWTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:19:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbXEVWTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:19:09 -0400
Date: Tue, 22 May 2007 15:07:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/69] -stable review
In-Reply-To: <1179870110.16656.2.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>  <4652070D.3090509@redhat.com>
  <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org> 
 <20070521212522.GL3429@sequoia.sous-sol.org>
 <1179870110.16656.2.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 May 2007, Romano Giannetti wrote:
> 
> It's an useful patch for me. Without it, my sony vaio pcg-fx701 was very
> erratic in resume (kernel 2.6.21.1; it works well with the .17 ubuntu
> kernel). With this patch, I have done 7 cycles flawlessly. Even the
> out-of-tree rtl8180 wireless driver [1] works ok across resumes. 

Ok, good to hear.

> The only problem is that there is an gaping delay of 60 seconds (more or
> less) on resume. I have the syslog trace copied below; could be a timer
> problem? Is it known? (It is scaring because the laptop seems dead
> during this time. I'm not and expert, but it seems here:

It's not known, no, and yeah, that's scary (and 60 seconds is long enough 
that most people would have grown bored and pushed the power button for 
five seconds, having considered the resume a failure).

> [    1.617972] pcmcia: registering new device pcmcia1.0 
> [   61.612517] PM: Writing back config space on device 0000:00:[...]
> 
> ...and time do not advance.

Do you mean that doing "date" twice does not increase the seconds? If so, 
that's almost certainly related to the gaping delay. Which timer do you 
end up using (what does "dmesg | grep clocksource" say)? Does adding 
"clocksource=acpi_pm" to the kernel command line change things?

Also, what does your lspci look like?

		Linus
