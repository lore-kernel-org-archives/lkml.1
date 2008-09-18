Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYIRXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYIRXqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbYIRXqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:46:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38387
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756268AbYIRXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:46:40 -0400
Date: Thu, 18 Sep 2008 16:46:27 -0700 (PDT)
Message-Id: <20080918.164627.94070091.davem@davemloft.net>
To: benli@broadcom.com
Cc: riel@redhat.com, mchan@broadcom.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2: Promote vector field in bnx2_irq structure from
 u16 to unsigned int
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221667442-4495-2-git-send-email-benli@broadcom.com>
References: <20080916190144.46f534b4@bree.surriel.com>
	<1221667442-4495-1-git-send-email-benli@broadcom.com>
	<1221667442-4495-2-git-send-email-benli@broadcom.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Benjamin Li" <benli@broadcom.com>
Date: Wed, 17 Sep 2008 09:04:02 -0700

> The bnx2 driver stores/uses the irq value from the pci_dev internally.
> But when it stores the irq value, it has been performing an
> integer demotion.  Because of the recent changes made to
> arch/x86/kernel/io_apic.c, the new method in creating the irq value
> (using build_irq_for_pci_dev()) has exposed this bug on x86 systems.
> 
> Because of this demotion when calling request_irq() from
> bnx2_request_irq(), the driver would get a return code of -EINVAL.
> This is because the kernel could not find the requested irq descriptor.
> By storing the irq value properly, the kernel can find the correct
> irq descriptor and the bnx2 driver can operate normally.
> 
> Signed-off-by: Benjamin Li <benli@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Applied to net-2.6, thanks!
