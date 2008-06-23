Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYFWNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYFWNOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYFWNOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:14:47 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56056 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYFWNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:14:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18527.41440.273383.388943@frecb006361.adech.frec.bull.fr>
Date: Mon, 23 Jun 2008 15:15:12 +0200
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Solofo.Ramangalahy@bull.net, linux-kernel@vger.kernel.org,
       Matt Helsley <matthltc@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
In-Reply-To: <484A9D52.2020703@colorfullife.com>
References: <20080605145712.116223941@bull.net>
	<484A9D52.2020703@colorfullife.com>
X-Mailer: VM 8.0.9 under Emacs 23.0.50.1 (i486-pc-linux-gnu)
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

This part is more difficult to answer than the other one:
> The whole configuration can be done from user space, thus I assumed that
> a sysctl.conf value [...] could do the job

Yes, while this is (still) possible, this can become cumbersome with
namespaces, hotplug, ...

> (or in the worst case: a dbus/hal daemon that
> updates /proc/sys/kernel/msgnmb) [...]

This would probably mean one daemon per ipc namespace.
The patches seems lighter.

There has been related discussions regarding kernel
space vs. userspace approach in the threads:
. "Change in default vm_dirty_ratio"
  http://lkml.org/lkml/2007/6/18/471
. "[RFC][PATCH 0/6] Automatic kernel tunables (AKT)"
  http://lkml.org/lkml/2007/1/16/16
(and probably others)

So it seems there is no consensus in doing it either way: kernel or
user space.

Humm... now this make me think that you did not change the MSGMNB
value when you changed MSGMNI and MSGMAX.
Maybe that was on purpose?

-- 
solofo
