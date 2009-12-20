Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZLTMwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZLTMwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZLTMwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:52:34 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:62869 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471AbZLTMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:52:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEADqpLUtGGNs5/2dsb2JhbACBSs94hC4EgWWEBA
Date: Sun, 20 Dec 2009 07:52:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: leonid.moiseichuk@nokia.com, Viktor.Rosendahl@nokia.com, tony@atomide.com,
       eero.tamminen@nokia.com
Cc: Felipe Balbi <felipe.balbi@nokia.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RELEASE] LTTng 0.183/0.183o
Message-ID: <20091220125228.GA29204@Krystal>
References: <20091204160633.GA29864@Krystal> <20091213194210.GA3149@nokia.com> <20091216213546.GA5609@Krystal> <20091216222916.GA11101@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091216222916.GA11101@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:48:22 up 3 days, 21:06,  4 users,  load average: 0.10, 0.48,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > Hi !
> > 
> > I just released LTTng 0.182 for mainline kernel 2.6.32. It fixes ppc440
> > build and, more importantly, adds full support for ARM omap3 to the
> > trace clock:
> > 
> > - Power management support (suspend/resume, idle)
> > - DVFS support
> > 
> > Basically, the infrastructure is based on the 32k timer as external
> > time source, but uses the ccnt register to read the time base quickly at
> > each event. The trace clock is responsible for extending the 32-bit
> > counter to 64-bit, and for resynchronizing it on the 32k clock when
> > necessary.
> > 
> > I did all development and testing of the omap3 features on top of a
> > linux-omap-2.6 2.6.32-rc8 kernel and then reintegrated the patches in
> > the main LTTng tree. I only build-tested the port to main LTTng tree.
> > 
> > I should put the linux-omap-2.6-lttng tree online shortly, along with
> > the corresponding patchset.
> 
> .. and the corresponding patchset and git tree for the omap/pm tree,
> based on kernel 2.6.32-rc8:
> 
> git://lttng.org/linux-omap-pm-2.6-lttng.git
> 
> http://lttng.org/files/lttng/patch-omap-pm-2.6.32-rc8-lttng-0.182o.tar.bz2
> 
> (it is actually a mix of lttng 0.180 to 0.182).

Version 0.183/0.183o turns the periodic resync timer into a timer only
launched when actual DVFS frequency change occurs (it is used to ensure
very frequent DVFS freq. change do not generate a high rate of 32k clock
reads).

Also, I don't want to take any chance, and therefore don't assume the
ccnt register is stopped in idle. This version now additionally makes
sure to stop the ccnt register when going to idle/sleep.

Mathieu


> 
> Have fun !
> 
> Mathieu
> 
> > 
> > Feedback is welcome !
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
