Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXL3OVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXL3OVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXL3OVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:21:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXL3OVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:21:40 -0500
Date: Sun, 30 Dec 2007 15:21:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on
	x86-64
Message-ID: <20071230142109.GK16946@elte.hu>
References: <200712281353.37976.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712281353.37976.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Document the fact that __save_processor_state() has to save all CPU 
> registers referred to by the kernel in case a different kernel is used 
> to load and restore a hibernation image containing it.

ok - so i guess i should drop this from x86.git:

 @@ -53,7 +53,6 @@ void __save_processor_state(struct saved
         ctxt->cr2 = read_cr2();
         ctxt->cr3 = read_cr3();
         ctxt->cr4 = read_cr4();
 -       ctxt->cr8 = read_cr8();
  }

right? But i'm wondering - are we really ever resuming to a different 
kernel version, for this to be an issue?

	Ingo
