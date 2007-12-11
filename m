Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXLKPfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXLKPfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLKPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:35:03 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44559 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXLKPfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:35:00 -0500
Message-Id: <20071211153845.766147000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 11 Dec 2007 16:38:45 +0100
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com
Subject: [RFC PATCH 0/2] Change default MSGMNI tunable to scale with system memory
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On large systems we'd like to allow a larger number of message queues.
In some cases up to 32K. However simply setting MSGMNI to a larger value may
cause problems for smaller systems.

The first patch of this series introduces a default maximum number of message
queue ids that scales with the total amount of memory.

Since msgmni is per namespace and there is no amount of memory dedicated to
each namespace so far, the second patch of this series scales msgmni to
the number of ipc namespaces.

I still have 2 issues that I'll try to solve next:
  . use hotplug_memory_notifier() with a callback routine that would recompute
    msgmni each time memory is brought offline / online. The issue here is
    that I couldn't find a simple way to walk through all the nsproxy
    structures (without walking through the task structures).
  . add a new notification mechanism that would recompute all the msg_ctlmni
    tunables each time an ipc namespace is created / removed.
    

These patches should be applied to 2.6.24-rc4, in the following order:

[PATCH 1/2]: ipc_scale_msgmni_with_totalram.patch
[PATCH 2/2]: ipc_scale_msgmni_with_namespaces.patch

Note: a big thank to Matt Helsley who gave me a help!

Regards,
Nadia

--
