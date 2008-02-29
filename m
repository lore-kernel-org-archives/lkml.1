Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbYB2Mtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbYB2Mtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYB2MtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:49:24 -0500
Received: from the.earth.li ([217.147.81.2]:50059 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbYB2MtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:49:23 -0500
X-Greylist: delayed 3386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 07:49:23 EST
Date: Fri, 29 Feb 2008 11:52:57 +0000
From: Simon Huggins <huggie@earth.li>
To: linux-kernel@vger.kernel.org
Subject: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080229115256.GG24533@paranoidfreak.co.uk>
Mail-Followup-To: huggie@earth.li, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please Cc me on replies ]

I had a bug with sdhci which Pierre Ossman looked at for me.

In the end essentially the fix was to use HZ=1000 and nothing else.
Pierre seemed to think that this was a bug in the scheduler.

I'm interested if someone who groks the scheduler could take a look at
the mmc/* code and see if it's abusing HZ or if there's anything
obviously wrong there.  If it's not then perhaps there really is a bug
in the scheduler?

See
http://list.drzeus.cx/pipermail/sdhci-devel/2008-February/002164.html
http://list.drzeus.cx/pipermail/sdhci-devel/2008-January/002142.html

Here's the log that caused him to suspect the scheduler:
http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002086.html
and his post saying so:
http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002087.html

Originally I tried to narrow it down:
http://list.drzeus.cx/pipermail/sdhci-devel/2007-November/002072.html
and shows a commit that seemed to "fix" it for me
http://list.drzeus.cx/pipermail/sdhci-devel/2007-November/002072.html
but apparently the commit I reverted was good
http://list.drzeus.cx/pipermail/sdhci-devel/2007-November/002078.html

I'm happy to provide more information or try different kernels/config
options etc (I really should upgrade the kernel on my laptop anyway).

Thanks,

-- 
----------(   "An excellent suggestion sir, with only two    )----------
Simon ----(            minor flaws...." - Kryten             )---- Nomis
                             Htag.pl 0.0.22
