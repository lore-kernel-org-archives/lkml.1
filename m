Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXEJTBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXEJTBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbXEJTAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:00:53 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:45380 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbXEJTAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:00:52 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 11 May 2007 00:29:25 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, mingo@elte.hu, sripathik@in.ibm.com
Subject: [PATCH -mm 0/2] Redo write_trylock_irqsave() in -mm
Message-ID: <Pine.LNX.4.64.0705110023020.30531@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-mm recently added a write_trylock_irqsave() implementation. We can do
a better implementation than that, so we're able to:

1. Have a slightly faster implementation
2. Have a far lesser invasive patch (add fewer lines, touch fewer files)
3. Be consistent in style with the spin_trylock_irqsave() of mainline and -mm

(http://lkml.org/lkml/2007/5/9/575)

> For the sake of completeness of the API, we could also add a
> read_trylock_irqsave, but I'd be against the _irq variants (or should
> we call them hazards) that don't save / restore.

[PATCH -mm 1/2] Kills the previous implementation of write_trylock_irqsave()

[PATCH -mm 2/2] Reintroduces the new implementation of write_trylock_irqsave()

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

