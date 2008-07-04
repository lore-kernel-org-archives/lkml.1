Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYGDVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYGDVUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYGDVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:20:28 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:5920 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYGDVU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:20:27 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
Date: Fri,  4 Jul 2008 23:20:24 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:02.0486 (UTC) FILETIME=[BE64EB60:01C8DE1A]
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

-Andi 

