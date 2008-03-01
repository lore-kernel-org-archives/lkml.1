Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbYCAWAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbYCAWAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbYCAWAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:00:07 -0500
Received: from main.gmane.org ([80.91.229.2]:58190 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYCAWAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in	dm-crypt
Followup-To: gmane.linux.kernel.device-mapper.dm-crypt
Date: Sat, 01 Mar 2008 22:59:33 +0100
Message-ID: <fqcjj9$5bv$1@ger.gmane.org>
References: <200802281924.03996.rrs@researchut.com>	<20080228232048.51e28c1d.akpm@linux-foundation.org>	<20080229184649.GJ1788@agk.fab.redhat.com>	<200803010029.18320.rrs@researchut.com> <47C9AEF3.7040507@redhat.com> <47C9AF8F.2050502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bras-co-85-197-3-127.westend.de
User-Agent: KNode/0.10.5
Cc: dm-devel@redhat.com, dm-crypt@saout.de
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz wrote:
> (the same patch for 2.6.24)

Observations using this patch:

* I did not get a Soft Lockup during my tests so far.

* The latency problems I experienced when writing massive amounts of data to
  an encrypted partitions are improved, though not solved. Using the "dd
  if=/dev/zero of=test.null bs=4M count=1024 ; rm test.null" approach
  mentioned in the other thread, the system stays more responsive and even
  listening to music works more or less, although there are still audible
  interruptions. A few times during the write, CPU usage will spike and IO
  (including music playing in Amarok) will stall for about 0.5 seconds or a
  second.

* This patch seems to hurt performance, I got much lower thoughput and the
  system was never fully loaded, ie. gkrellm showed both cores to run
  between 10% and 40% with a combined CPU utilization fo 30% most of the
  time.
  I got unstable timings from my dd command, but targetting the reiserfs
  partition I got around 18 MB/sec and 34 MB/sec instead of the 41 MB/sec I
  achieved in my tests yesterday.
  So this looks like a viable work around if it reliably avoids the Soft
  Lockup, but it does not seem to be a perfect solution.
  (Addendum: I just got 41 MB/sec with this patch, with an otherwise nearly
  idle system, ie. lots of active processes but none doing anything serious.
  The numbers before applying the patch were much more stable and generally
  higher. Now simply playing or not playing an OGG seems to make the
  difference between 40 MB/sec and 30 MB/sec.)

Greetings,

  Gunter

