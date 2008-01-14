Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYANP5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYANP5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYANP5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:57:46 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43364 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYANP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:57:45 -0500
Message-Id: <20080114155402.690906000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 14 Jan 2008 16:54:02 +0100
From: Nadia.Derbey@bull.net
To: akmp@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com
Subject: [RFC PATCH 0/4] [RESEND] Change default MSGMNI tunable to scale with lowmem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resending the set of patches after Andrew's remark about the fact that we
should take the lowmem into account, rather than the total ram.

Also, these patches have been enhanced with memory hotplug management.

Note: they now have to applied to 2.6.24-rc7.

-------------------

On large systems we'd like to allow a larger number of message queues.
In some cases up to 32K. However simply setting MSGMNI to a larger value may
cause problems for smaller systems.

The first patch of this series introduces a default maximum number of message
queue ids that scales with the amount of lowmem.

Since msgmni is per namespace and there is no amount of memory dedicated to
each namespace so far, the second patch of this series scales msgmni to
the number of ipc namespaces.

In the last patch, a notifier block is added to the ipc namespace structure to
manage memory hotplug. The callback routine is activated upon memory
add/remove and it recomputes msgmni. One callback routine is added to the
memory notifier chain each time an ipc namespace is allocated. It is removed
when the coresponding ipc namespace is freed.

I still have 1 issue that I'll try to solve next:
  . use the notification mechanism to recompute all the msg_ctlmni each time
    an ipc namespace is created / removed.
    

These patches should be applied to 2.6.24-rc7, in the following order:

[PATCH 1/4]: ipc_scale_msgmni_with_lowmem.patch
[PATCH 2/4]: ipc_scale_msgmni_with_namespaces.patch
[PATCH 3/4]: ipc_slab_memory_callback_prio_to_const.patch
[PATCH 4/4]: ipc_recompute_msgmni_on_memory_hotplug.patch


Regards,
Nadia

--
