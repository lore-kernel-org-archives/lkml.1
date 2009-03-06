Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZCFFvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZCFFvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZCFFvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:51:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:46053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZCFFvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:51:08 -0500
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090305125919.GA5474@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop>  <20090305125919.GA5474@soziologie.ch>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 16:50:29 +1100
Message-Id: <1236318629.7260.120.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As already said in an earlier mail, this does not make any difference. I
> now ran some more tests:
> 
> -> with ppc32_defconfig: same results, resume with your commit is
>    broken, I did not yet test if reverting the commit fixes resume.
>    Please tell me if you are interested in this result.
> -> with a minimal config (attached): resume does not work at all with or 
>    without your commit. I suspect this is another bug with the same
>    symptoms. 
> 
> If you have any ideas, I would be happy to do further tests. I could
> also send you my compiles kernel (as a Debian package or a tar file) or
> you could send me your working kernel image to see if it also works for
> me. 

I think that .config fails due to the lack of CPU_FREQ support. I think
I remember that specifically this powerbook model boots at low speed and
fails to resume if not suspended at high speed. The cpufreq driver for
powermacs knows about that and ramps up the frequency before suspend.

Can you give that a try ?

In fact I verified on mine that your minimum config fails the same way
you described but it works when I re-enable cpufreq support.

We might want to do something to warn people in this situation.. maybe
the sleep code can somewhat verify that cpufreq is there.

Cheers,
Ben.
 

