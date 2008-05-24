Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYEXRGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYEXRGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYEXRF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:05:56 -0400
Received: from sing.entic.net ([208.64.63.147]:52537 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbYEXRFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:05:55 -0400
X-Greylist: delayed 1736 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2008 13:05:55 EDT
Message-Id: <200805241636.m4OGaum4006162@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 24 May 2008 13:20:06 +0200
Subject: [PATCH 0/4] ipc/sem.c: cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some cleanup in ipc/sem:
- ipc/sem contained hand-written linked lists, they can be replaced with
  standard list_head lists.
- the locking was written before CLONE_SYSVSEM was introduced, with
  ulp->lock, it's now possible to free undo structures during IPC_RMID
  immediately.
- There is a (extremely unlikely) race in semtimedop(), it can access
  kfree'd memory.

The patches pass my own simple test cases, what do you think?

--
	Manfred
