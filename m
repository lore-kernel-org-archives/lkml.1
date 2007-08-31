Return-Path: <linux-kernel-owner+w=401wt.eu-S964956AbXHaLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbXHaLVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932661AbXHaLUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:20:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43270 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbXHaLUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:20:50 -0400
Message-Id: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:45 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com
Subject: [RFC][PATCH 0/6] An IPC implementation base on Linux IDRs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of months ago, I dropped a series of patches that introduced the
AKT framework (Automatic Kernel Tunables).

(see thread http://lkml.org/lkml/2007/1/16/16)

When reading the patches, people complained that I was trying to treat a
symptom, not the problem itself, and that it'd be better try to rewrite
things where necessary (better data structures / implementations).

(see http://lkml.org/lkml/2007/2/7/248)

I'm trying to achieve this for the IPC case, with this new series of patches:
after proposing a radix tree based implementation at the beginning of July,
I'm now proposing a new ipc implementation based on the Linux idr API.

In the current ipc implementation, the ipc structures pointers are stored
in an array that is resized each time the corresponding tunable is changed
(resized means that a new array is allocated with the new size, the old one
is copied into that new array and the old array is de-allocated).

With this new implementation, there is no need for the array resizing since
the size change becomes "natural".

With this completely dynamic implementation, it becomes possible to set the
kernel default maximum values higher in order to prevent early DoS feedback,
on configurations with a high amount of memory. Even if the maximum values are
huge, no memory space will be wasted, since the allocations are done "on
demand". This is not the case with the existing array based implementation:
an array of the maximum number of entries is allocated only if a single ipc
object is actually created.

These patches should be applied to 2.6.23-rc2, in the following order:

[PATCH 1/6]: ipc_idr.patch
[PATCH 2/6]: ipc_syscalls.patch
[PATCH 3/6]: ipc_get.patch
[PATCH 4/6]: ipc_lock_and_check.patch
[PATCH 5/6]: ipcid_to_idx.patch
[PATCH 6/6]: ipc_buildid.patch

--

Regards,
Nadia
