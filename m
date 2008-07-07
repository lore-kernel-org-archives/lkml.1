Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYGGXKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYGGXKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYGGXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:10:08 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:20250 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYGGXKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:10:07 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/10] Use 64bit x86 machine check code for 32bit too v2
Date: Tue,  8 Jul 2008 01:10:02 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:38.0807 (UTC) FILETIME=[8D6D1E70:01C8E085]
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

v2: Fix compilation problems noted by hpa in some configurations
    Fix strict_strtoul() conversion

-Andi 

