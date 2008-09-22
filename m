Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYIVR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYIVR7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYIVR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:59:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbYIVR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:59:34 -0400
Date: Mon, 22 Sep 2008 19:59:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: when booting with reset_devices, clear
	the performance counters
Message-ID: <20080922175924.GH10535@elte.hu>
References: <20080922171408.GJ16840@redhat.com> <20080922174748.GC10535@elte.hu> <20080922175803.GK16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922175803.GK16840@redhat.com>
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


* Aristeu Rozanski <aris@redhat.com> wrote:

> > > P4s have a quirk that makes necessary to clear P4_CCCR_OVF bit on the CCCR
> > > everytime the PMI is triggered. When booting the kernel with reset_devices
> > > (more specific kdump case), the counters reach zero and the PMI will be
> > > generated. This is not a problem on other processors but on P4s, it'll
> > > continue to generate NMIs until that bit is cleared. Since there may be
> > > other users of the performance counters, clear and disable all of them
> > > when booting with reset_devices option.
> > > 
> > > We have a P4 box here that crashes because of this problem. Since the kdump
> > > kernel usually boots with only one processor active, the second logical
> > > unit won't be set up, therefore, MSR_P4_IQ_CCCR1 (and other performance
> > > counter registers) won't be cleared and P4_CCCR_OVF may be still set because
> > > the previous kernel was using this register. An NMI is triggered because of
> > > the MSR_P4_IQ_CCCR1 right after the NMI delivery is enabled, triggering the
> > > race fixed on my previous email.
> > > 
> > > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> > > Acked-by: Don Zickus <dzickus@redhat.com>
> > > Acked-by: Prarit Bhargava <prarit@redhat.com>
> > > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > 
> > applied to tip/x86/nmi-watchdog, thanks.
> > 
> > i'm wondering, is this fix a v2.6.27 candidate?
> I believe so. Even being a small affected group (P4 based boxes using NMI
> watchdog and kdump), it's fully reproducible.

is there a bugzilla.kernel.org entry for it? If not, could you please 
file it? Thanks,

	Ingo
