Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXLUPgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXLUPgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:36:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXLUPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:35:52 -0500
Received: from saeurebad.de ([85.214.36.134]:50617 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbXLUPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:35:51 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: 2.6.24-rc5-git7: Reported regressions from 2.6.23
In-Reply-To: <87d4t05f5a.fsf@saeurebad.de> (Johannes Weiner's message of "Fri,
	21 Dec 2007 14:52:17 +0100")
Date: Fri, 21 Dec 2007 16:34:51 +0100
Message-ID: <87lk7o5aec.fsf@saeurebad.de>
References: <200712210212.02666.rjw@sisk.pl> <87d4t05f5a.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw, here is the oops as I pencil-copied it:

	NULL pointer deref
	
	EIP: wq_per_cpu
	
	queue_delayed_work_on()
	 do_dbs_timer()
	  cpufreq_governor_dbs()
	   __cpufreq_governor()
	    __cpufreq_set_policy()
	     speedstep_get()
	      cpufreq_add_dev()
	       handle_update()
	        sysdev_driver_register()
	         cpufreq_register_driver()
	          speedstep_init()
	           kernel_init()
	            ...

HTH

	Hannes
