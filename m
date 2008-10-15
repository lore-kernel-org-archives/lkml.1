Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYJOR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYJOR62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYJOR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:58:17 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61870 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYJOR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:58:16 -0400
Message-Id: <20081015174506.107691579@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 19:45:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 0/2] vdso support for s390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the two patches in this series add a vdso to s390 for three system calls:
1) gettimeofday
2) clock_getres for CLOCK_REALTIME and CLOCK_MONOTONIC
3) clock_gettime for CLOCK_REALTIME and CLOCK_MONOTONIC
The vdso code for gettimeofday is about 4-5 times faster than the system
call. Similar results for clock_gettime.

The first of the two patches changes the arch_setup_additional_pages
function. The second argument is unused and can be removed. For the
s390 vdso I want to know if the elf executable is dynamically linked
or not. Only if an interpreter is used the vdso is mapped. This adds
a second argument to arch_setup_additional_pages again but with a
different semantic.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

