Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXFGQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXFGQvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbXFGQvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:12 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46426 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbXFGQvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:12 -0400
Message-Id: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:02 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de
Subject: [RFC][PATCH 0/6] an IPC implementation based on Linux radix trees
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--

A couple of months ago, I dropped a series of patches that introduced the
AKT framework (Automatic Kernel Tunables).

(see thread http://lkml.org/lkml/2007/1/16/16)

When reading the patches people complained that I was trying to treat a
symptom, not the problem itself, and that it'd be better try to rewrite
things where necessary (better data structures / implementations).

(see http://lkml.org/lkml/2007/2/7/248)

I'm trying to achieve this for the IPC case, with this new series of patches:
a new ipc implementation based on the Linux radix tree API is proposed.

In the current ipc implementation, the ipc structures pointers are stored
in an array that is resized each time the corresponding tunable is changed
(resized means that a new array is allocated with the new size, the old one
is copied into that new array and the old array is de-allocated).

With this new implementation, there is no need for the array resizing since
the size change becomes "natural".

I'll try to come up in the near future, with ipc max values that scale better
to memory size: that way, the ipc tunables msgmni, semmni and shmmni should
become actual DoS limits.

These patches should be applied to 2.6.21, in the following order:

[PATCH 1/6]: ipc_radix_tree.patch
[PATCH 2/6]: ipc_rmid.patch
[PATCH 3/6]: ipc_gang_lookups.patch
[PATCH 4/6]: ipc_lock_and_check.patch
[PATCH 5/6]: ipcid_to_idx.patch
[PATCH 6/6]: ipc_findkey.patch

Regards,
Nadia
