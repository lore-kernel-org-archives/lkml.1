Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYJXMqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYJXMqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYJXMql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:46:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:44032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYJXMql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:46:41 -0400
Message-Id: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: maxk@qualcomm.com
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Date: Fri, 24 Oct 2008 07:45:42 -0500
Cc: LinuxPPC-dev list <linuxppc-dev@ozlabs.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears the default IRQ affinity changes from being just cpu 0 to  
all cpu's.  This breaks several PPC SMP systems in which only a single  
processor is allowed to be selected as the destination of the IRQ.

What is the right answer in fixing this?  Should we:

	cpumask_t irq_default_affinity = 1;

instead of

	cpumask_t irq_default_affinity = CPU_MASK_ALL?

- k
