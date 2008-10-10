Return-Path: <linux-kernel-owner+w=401wt.eu-S1764038AbYJJUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764038AbYJJUYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761647AbYJJUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:24:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761170AbYJJUYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:24:03 -0400
Date: Fri, 10 Oct 2008 22:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010202350.GA11090@elte.hu>
References: <48EFB4B2.2020508@canonical.com> <20081010201610.GA32164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010201610.GA32164@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
> > Affected: 2.6.24-2.6.27
> > 
> > Someone from the community found out, that after repeatedly unloading and
> > loading a device driver that uses MSI IRQs, the system eventually assigned
> > the vector initially reserved for IRQ0 to the device driver.
> > 
> > The reason for this is, that although IRQ0 is tied to the FIRST_DEVICE_VECTOR
> > when declaring the irq_vector table, the corresponding bit in the used_vectors
> > map is not set. So, if vectors are released and assigned often enough, the
> > vector will get assigned to another interrupt. This happens more often with
> > MSI interrupts as those are exclusively using a vector.
> > 
> > Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.
> > 
> > Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> 
> Hint, if you want patches to go into the -stable tree, just add:
> 	cc: Stable <stable@kernel.org>
> to the patch when you submit it in the signed-off-by area, and it will
> be automatically sent to us when it goes into the main kernel tree.

yes. Note that this is a special case, as there will be no upstream 
commit to tag with Cc: <stable@kernel.org>, because this bug got 
eliminated via not backportable means: APIC code unification.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
