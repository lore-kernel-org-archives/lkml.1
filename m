Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYGGG3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYGGG3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYGGG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:28:51 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYGGG2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:28:51 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
Date: Mon,  7 Jul 2008 08:28:32 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:09.0140 (UTC) FILETIME=[A5319540:01C8DFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit uses the 64bit machine check code which is better in many
ways on 32bit x86 too. This is also the basis for some future machine
check work.

The 64bit machine check code is in many ways much better than 
the 32bit machine check code: it is more specification compliant,
is cleaner, only has a single code base versus one per CPU, 
has better infrastructure for recovery, has a cleaner way to communicate
with user space etc. etc.

It requires testing especially on older systems (on newer
ones it should be already tested well in 64bit systems). 

The patchkit contains several parts:
- It ports over a few needed quirks (for older Intel and older
AMD CPUs) to the 64bit kernel.
- It changes the 64bit code to be 32bit clean in its data structures
(mostly just unsigned long -> u64 where needed) 
- It drops some unused functionality that cannot be easily implemented on 32bit
and didn't seem worth ifdefing

Tested by doing some software level error injection on a few
different machines

I request this code is merged into the appropiate tree for linux-next
for wider testing. It's not .27 ready, but hopefully .28, but it requires
wider exposure now.

Patches are also available for pulling from

git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce

-Andi 

