Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYIRK55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYIRK55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYIRK5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:57:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYIRK5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:57:49 -0400
Date: Thu, 18 Sep 2008 12:57:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-ID: <20080918105728.GF20967@elte.hu>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com> <48D159A7.5080907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D159A7.5080907@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> 8) The ability to accessed filtered messages a posteori (via dmesg), 
> which is something we currently take for granted.
>
> This *is* the fundamental difference between what Yinghai has now and 
> both your stuff and Yinghai's original proposal.  Not producing the 
> additional messages at all is inherently cheaper, sometimes *much* 
> cheaper, but it obviously means the information is not accessible at 
> all.

which is what we really want. If a bootup fails, the user has to repeat 
the bootup at least once with a verbosity level increased and with 
(hopefully) some sort of log capture facility attached.

So the point would be, if the user specified loglevel=all, we would get 
really comprehensive, one-stop-shop output.

> At the moment, I would argue that the fact that dmesg is, in effect, 
> more verbose than the kernel itself is a good thing; it makes dmesg 
> dumps more useful.

yes - but log messages not showing up on the physical console is already 
a task that is solved via regular loglevels. printks are being removed 
because even printing to the dmesg can be expensive (vsprintf is not the 
cheapest of functions, and most of dmesg shows up in the syslog and 
people want a clear, default, not too verbose output for that).

so the main feature of these patches is that we can cut out too verbose 
information by default, and we can reactivate it with a single central 
switch (and a repeated bootup - which has to be done anyway). Everything 
else is already solved via either traditional loglevels or pr_debug() 
based, build-time facilities.

	Ingo
