Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXJOLdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXJOLdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbXJOLd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:33:27 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:46716 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbXJOLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:33:26 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest =?iso-8859-1?q?time=09accounting=2E?=
Date: Mon, 15 Oct 2007 13:33:20 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46E550EF.5080209@bull.net> <471346B0.8050102@bull.net> <47134BCE.1080306@qumranet.com>
In-Reply-To: <47134BCE.1080306@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151333.21078.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 15. Oktober 2007 schrieb Avi Kivity:
> We can clear it a bit later, after local_irq_enable() in __vcpu_run().  
> However we need a nop instruction first because "sti" keeps interrupts 
> disabled for one more instruction.

Ah, I see. The host interrupt  behaves different and instead of running the
interrupt handler, it exits the vmrun on x86? The interrupt handler will be
called some cycles after the sti?
That is different to s390. We can run the guest code for a long time and the
host instruction pointer stays on the sie instruction. That means, we can 
interrupt sie and continue by simply setting the instrution pointer (PSW) 
back to the sie instruction.

Any idea how to make this proper on all architectures? I will have a look.

Christian
