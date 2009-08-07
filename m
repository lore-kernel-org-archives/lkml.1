Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZHGM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZHGM0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbZHGMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:25:48 -0400
Received: from rood.intersec.com ([88.191.78.202]:33726 "EHLO mx2.intersec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660AbZHGMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:25:47 -0400
X-Intersec-Trusted-Host: yes
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: perf-record fix and UI improvement
Date: Fri,  7 Aug 2009 14:15:59 +0200
Message-Id: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.6.4.rc2.183.g9085a
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While toying with perf, I've noticed that perf record can easily enter
a busy loop when doing something as silly as:

    $ perf record -A ls

I've searched why and here are the patches:

 [PATCH 1/2] perf util: do_read should fail on EOF instead of busy-looping.

   Yeah, do_read here really wants to read a known size, not being able
   to should die(), not busy-lopp ;)
   That was the cause for the bug.


 [PATCH 2/2] perf-record: improve -A UI for empty or non-existent perf.data

   Though with 1/2 `git record -A ls` would then fail miserably with
   some kind of "cannot read" error, which sucks. So this patch
   understands -A as a "append or create if file is empty or inexistant"

   This fact may deserve to be documented properly, if so just tell me
   I'll send an updated patch for Documentation/


I'm kind of new to the kernel world, so I hope I sent the patches to the
proper persons.
-- 
Intersec <http://www.intersec.com>
Pierre Habouzit <pierre.habouzit@intersec.com>
Tél : +33 (0)1 5570 3346
Mob : +33 (0)6 1636 8131
Fax : +33 (0)1 5570 3332
37 Rue Pierre Lhomme
92400 Courbevoie

