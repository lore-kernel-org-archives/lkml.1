Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZAKIbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZAKIbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZAKIbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:31:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38996
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZAKIbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:31:03 -0500
Date: Sun, 11 Jan 2009 00:31:03 -0800 (PST)
Message-Id: <20090111.003103.39502700.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: sparclinux@vger.kernel.org, travis@sgi.com, mingo@elte.hu
Subject: cpumask change causes sparc build bustage
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_of_pcibus'
drivers/pci/probe.c:56: warning: assignment makes pointer from integer without a cast

Almost certainly caused by:

commit 588235bb53f2c215f0d4b08fd30b461fedc3338e
Author: Mike Travis <travis@sgi.com>
Date:   Sun Jan 4 05:18:02 2009 -0800

    cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
    
    Impact: use new cpumask API to reduce stack usage
    
    Replace the local cpumask_t variable with a pointer to the
    const cpumask that needs to be printed.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

I'm surprised linux-next builds didn't catch this.
