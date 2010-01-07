Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333Ab0AGEWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0AGEWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021Ab0AGEWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:22:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47127
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755956Ab0AGEWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:22:23 -0500
Date: Wed, 06 Jan 2010 20:22:31 -0800 (PST)
Message-Id: <20100106.202231.90723930.davem@davemloft.net>
To: anton@samba.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, akpm@linux-foundation.org
Subject: Re: [patch 5/6] sparc: cpumask_of_node() should handle -1 as a node
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100106045525.329010098@samba.org>
References: <20100106045509.245662398@samba.org>
	<20100106045525.329010098@samba.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>
Date: Wed, 06 Jan 2010 15:55:14 +1100

> pcibus_to_node can return -1 if we cannot determine which node a pci bus
> is on. If passed -1, cpumask_of_node will negatively index the lookup array
> and pull in random data:
> 
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> 00000000,00000003,00000000,00000000
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
> 64-65
> 
> Change cpumask_of_node to check for -1 and return cpu_all_mask in this
> case:
> 
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> ffffffff,ffffffff,ffffffff,ffffffff
> # cat /sys/devices/pci0000:00/0000:00:01.0/local_cpulist
> 0-127
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: David S. Miller <davem@davemloft.net>
