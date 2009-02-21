Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZBUNg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZBUNg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 08:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZBUNgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 08:36:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:32738 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZBUNgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 08:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GTT4/vAinOmzpsSgqG8rEKNWR7ES/RXtGCW7A0Hk6CIAaBLFN13BQWliZddJb4SqLg
         5S6iMKC0gbTQImnk6D6igS9Whi+UQ5nVgsmaBfigjm0Mit27jac64Dh/xmG/n0Tn+8iM
         sgvlmi1OWLkkgvMB+aWqXOxjbiIvTSmIETPfY=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: 
Date: Sat, 21 Feb 2009 14:36:00 +0100
Message-Id: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here comes a kmemcheck update. I found out how to solve the P4 REP problem
cleanly, and by adding the right hooks in the DMA API, we were able to get
page-allocator support with no additional false positives.

 arch/x86/include/asm/dma-mapping.h |    6 ++
 arch/x86/include/asm/thread_info.h |    4 +-
 arch/x86/kernel/cpu/intel.c        |   23 +++++++
 arch/x86/mm/kmemcheck/kmemcheck.c  |  119 +-----------------------------------
 arch/x86/mm/kmemcheck/opcode.c     |   13 +----
 arch/x86/mm/kmemcheck/opcode.h     |    3 +-
 arch/x86/mm/kmemcheck/shadow.c     |    8 +++
 include/linux/gfp.h                |    5 ++
 include/linux/kmemcheck.h          |   33 +++++++++--
 mm/kmemcheck.c                     |   45 ++++++++++----
 mm/page_alloc.c                    |    8 +++
 mm/slab.c                          |   15 +++--
 mm/slub.c                          |   23 ++++++--
 13 files changed, 143 insertions(+), 162 deletions(-)

(Ingo: Don't apply to -tip, I'll send a pull request later.)


Vegard
