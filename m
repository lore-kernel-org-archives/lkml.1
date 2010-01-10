Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926Ab0AJCJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0AJCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 21:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346Ab0AJCJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 21:09:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0AJCJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 21:09:57 -0500
Date: Sun, 10 Jan 2010 03:09:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33 pagemap endless read loop
Message-ID: <20100110020955.GB25323@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


An LTP run on x86-64/2.6.33-rc3 run right now results in "proc01" hanging

lr-x------  1 root root 64 2010-01-10 02:28 7 -> /proc/2679/task/2679/pagemap

strace shows an endless loop of

read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 1024
read(7, "\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\6\0\0\0"..., 1024) = 10

cat of that file hangs in the same way so it seems like a kernel bug.
A cat of /proc/2679/pagemap also hangs, in fact any pagemap cat seems to.

I tried to revert the latest change from Horiguchi-san:

commit 5dc37642cbce34619e4588a9f0bdad1d2f870956
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Mon Dec 14 18:00:01 2009 -0800

    mm hugetlb: add hugepage support to pagemap

but that didn't fix it, so it must be something else.

Haven't done further bisect or anything, should be easy to reproduce.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
