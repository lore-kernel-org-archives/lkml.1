Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYI3JwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYI3JwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYI3JwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:52:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYI3Jv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:51:59 -0400
Date: Tue, 30 Sep 2008 11:51:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors
	bitmap.
Message-ID: <20080930095149.GA7557@elte.hu>
References: <48E0DA7C.5010403@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0DA7C.5010403@canonical.com>
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


> Someone from the community found out, that after repeatedly unloading 
> and loading a device driver that uses MSI IRQs, the system eventually 
> assigned the vector initially reserved for IRQ0 to the device driver.

> The reason for this is, that although IRQ0 is tied to the 
> FIRST_DEVICE_VECTOR when declaring the irq_vector table, the 
> corresponding bit in the used_vectors map is not set. So, if vectors 
> are released and assigned often enough, the vector will get assigned 
> to another interrupt. This happens more often with MSI interrupts as 
> those are exclusively using a vector.
>
> Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.

hi, the IO-APIC code got unified in the x86 tree for v2.6.28.

So could you please send the fix against tip/master:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
