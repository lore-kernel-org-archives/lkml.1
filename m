Return-Path: <linux-kernel-owner+w=401wt.eu-S1030891AbXCNUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030891AbXCNUjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030894AbXCNUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:39:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58302 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030891AbXCNUjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:39:32 -0400
Date: Wed, 14 Mar 2007 21:38:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       paulus@au.ibm.com, schwidefsky@de.ibm.com,
       Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
Message-ID: <20070314203826.GA15394@elte.hu>
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F84E39.7030507@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I added stolen time accounting to xen-pv_ops last night.  For Xen, at 
> least, it wasn't hard to fit into the clockevent infrastructure.  I 
> just update the stolen time accounting for each cpu when it gets a 
> timer tick; they seem to get a tick every couple of seconds even when 
> idle.

touching the 'timer tick' is the wrong approach. 'stolen time' only 
matters to the /scheduler tick/. So extend the hypervisor interface to 
allow the injection of 'virtual' scheduler tick events: via the use of a 
special clockevents device - do not change clockevents itself.

	Ingo
