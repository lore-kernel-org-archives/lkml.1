Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0BMW0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:26:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60390 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0BMW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:26:14 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B762137.4050604@zytor.com>
	<m1k4uhrcqm.fsf@fess.ebiederm.org>
	<83b97429-92d3-498f-b1a8-a6969713f7ba@email.android.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 14:26:04 -0800
In-Reply-To: <83b97429-92d3-498f-b1a8-a6969713f7ba@email.android.com> (Jeremy Fitzhardinge's message of "Sat\, 13 Feb 2010 14\:12\:57 -0800")
Message-ID: <m1hbpkojr7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I don't have the code in front of me, but I think that change should be OK.  Xen just wants to initiate interrupt delivery for a given irq.  At least for x86; I won't make any claims for ia64.

Thanks.

For ia64 the change should be a noop, generic_handle_irq_desc calls
__do_IRQ when needed.

On x86 the big differences are:
- No more stack overflow check.
- Not switching to the irq stack for i386.

Eric
