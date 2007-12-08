Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXLHIkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXLHIkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 03:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXLHIkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 03:40:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbXLHIkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 03:40:07 -0500
Date: Sat, 8 Dec 2007 09:39:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071208083939.GD30997@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475A5188.6070809@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Unfortunately no change here.

could you try to revert this change:

-int softlockup_thresh = 10;
+int softlockup_thresh = 60;

i.e. change the value of softlockup_thresh back to 10. You should be 
able to tweak this runtime as well, without patching the kernel:

  echo 10 > /proc/sys/kernel/softlockup_thresh

	Ingo
