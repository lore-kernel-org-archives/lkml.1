Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYFDJLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYFDJLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbYFDJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:10:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:49504 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYFDJKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:10:04 -0400
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions
	with callbacks (not word wrapped)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200806031449.14385.borntraeger@de.ibm.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
	 <200806031449.14385.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 19:06:42 +1000
Message-Id: <1212570402.9496.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 14:49 +0200, Christian Borntraeger wrote:
> This patch tries to change hvc_console to not use request_irq/free_irq if
> the backend does not use irqs. This allows virtio_console to use hvc_console
> without having a linker reference to request_irq/free_irq.
> 
> The irq specific code is moved to hvc_irq.c and selected by the drivers that
> use irqs (System p, System i, XEN).
> 
> I replaced "irq" with the opaque name "data". The request_irq and free_irq
> calls are replaced with notifier_add and notifier_del. I have also changed
> the code a bit to call the notifier_add and notifier_del inside the spinlock
> area as the callbacks are found via hp->ops.
> 
> Feedback is appreciated.

I haven't looked at the patch proper but I agree with the basic
premises. We routinely use hvc_console for things that don't have an
irq. In fact, David even did a backend hooking up to udbg which is
useful when bringing up weird stuffs :-)

Cheers,
Ben.


