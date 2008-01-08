Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYAHKgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYAHKgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYAHKgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:36:00 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:40593 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYAHKf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:35:58 -0500
X-Greylist: delayed 2759 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 05:35:56 EST
Message-Id: <20080108094903.484613061@nttdata.co.jp>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 18:49:03 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO #6 00/21] TOMOYO Linux - MAC based on process invocation history.
X-OriginalArrivalTime: 08 Jan 2008 09:49:55.0787 (UTC) FILETIME=[D2E379B0:01C851DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"TOMOYO Linux" is our work in the field of security enhancement for Linux.
This is the 6th submission of TOMOYO Linux.
(http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#mainlining)

Changes since previous (November 17th) submission:

* Added security goal document. (Documentation/TOMOYO.txt)
   This document is intended to specify the security goal that TOMOYO
   Linux is trying to achieve. Thread URL:
     http://lkml.org/lkml/2007/12/25/18

* Added environment variable name control functionality.
   Users can restrict the environment variable's names passed to
   execve() for each domain.

* Refreshed patches for the latest -mm tree.
   Patches are for 2.6.24-rc6-mm1

The possibility of AB-BA deadlock has been pointed out and argued in
http://lkml.org/lkml/2007/11/5/388 .
We believe that LSM functions shouldn't access namespace_sem, so
we chose to write a set of wrapper functions to pass "struct vfsmount" to
LSM functions using "struct task_struct". This method is suggested at
http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg01712.html .

We wish Linux to merge either AppArmor's "Pass struct vfsmount to ..." patches or
our patches marked as [02/21], [03/21], [04/21] into mainline kernel
so that AppArmor and TOMOYO Linux can safely access "struct vfsmount" from LSM.

Patches consist of five types.
 * [TOMOYO 01/21]:    Documentation.
 * [TOMOYO 02-05/21]: Essential modifications against -mm kernel.
 * [TOMOYO 06-19/21]: LSM implementation of TOMOYO Linux.
 * [TOMOYO 20/21]:    Makefile and Kconfig.
 * [TOMOYO 21/21]:    Optional modifications against -mm kernel.

We are trying to make a fair ¡Èsecure Linux¡É comparison table, it should
explain the differences between TOMOYO Linux and AppArmor.
(http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison)

We would like TOMOYO Linux to be added into -mm tree so that more
people can try. Any kind of feedbacks for the patches and the table
would be appreciated.
-- 
