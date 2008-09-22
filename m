Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYIVR55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYIVR55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYIVR5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:57:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIVR5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:57:48 -0400
Date: Mon, 22 Sep 2008 13:58:09 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH] NMI watchdog: when booting with reset_devices, clear
	the performance counters
Message-ID: <20080922175803.GK16840@redhat.com>
References: <20080922171408.GJ16840@redhat.com> <20080922174748.GC10535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922174748.GC10535@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > P4s have a quirk that makes necessary to clear P4_CCCR_OVF bit on the CCCR
> > everytime the PMI is triggered. When booting the kernel with reset_devices
> > (more specific kdump case), the counters reach zero and the PMI will be
> > generated. This is not a problem on other processors but on P4s, it'll
> > continue to generate NMIs until that bit is cleared. Since there may be
> > other users of the performance counters, clear and disable all of them
> > when booting with reset_devices option.
> > 
> > We have a P4 box here that crashes because of this problem. Since the kdump
> > kernel usually boots with only one processor active, the second logical
> > unit won't be set up, therefore, MSR_P4_IQ_CCCR1 (and other performance
> > counter registers) won't be cleared and P4_CCCR_OVF may be still set because
> > the previous kernel was using this register. An NMI is triggered because of
> > the MSR_P4_IQ_CCCR1 right after the NMI delivery is enabled, triggering the
> > race fixed on my previous email.
> > 
> > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> > Acked-by: Don Zickus <dzickus@redhat.com>
> > Acked-by: Prarit Bhargava <prarit@redhat.com>
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> applied to tip/x86/nmi-watchdog, thanks.
> 
> i'm wondering, is this fix a v2.6.27 candidate?
I believe so. Even being a small affected group (P4 based boxes using NMI
watchdog and kdump), it's fully reproducible.

-- 
Aristeu

