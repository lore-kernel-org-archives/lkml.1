Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYCYMuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYCYMuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYCYMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:49:53 -0400
Received: from picture.zai.com ([12.47.112.36]:11933 "EHLO york.rivers.zai.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750707AbYCYMtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:49:52 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 08:49:52 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
Subject: Performance changes between 2.6.13 and 2.6.23
Date: Tue, 25 Mar 2008 08:34:40 -0400
Message-ID: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Performance changes between 2.6.13 and 2.6.23
Thread-Index: AciOdJhvdGEIdTBdT6GsLo2CoQ8XiA==
From: "Sanders, Rob M." <sanders-rob@zai.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Sanders, Rob M." <sanders-rob@zai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
  I've been lurking on the digest for some time (don't want to receive full lkml traffic at work) and saw the
posts about Wine performance regressions in 2.6.24.  Some of what I saw there, particularly Andi Kleen's 
responses, mirror something that I see on my box at home.  I had emailed Andi directly since I only read the
digest, and I'm posting this here at his suggestion.  Please CC: rms@zai.com with any replies, as I'm only 
getting the lkml digest.
  I'm running on a dual 2GHZ G5 Powermac w/2GB ram.  I recently upgraded from YDL4.0.91 (2.6.13 kernel) to
YDL6 (2.6.23 kernel) and noticed that the overall performance of the box seems more sluggish after the upgrade.
Of more particular concern, the main application that I build has seen a 4-5X slowdown in performance.  Under
YDL4.0.91 I could process roughly 1e8 data points in ~2 seconds, and under YDL6.0 I now process 1e8 data points
in ~8 seconds.  Total CPU loading (from top) is about 5%, under both systems.  The application spawns multiple
processes and uses semaphores and shared memory to move data between the processes.  When I use 'vmstat 3' the
single biggest difference I see between YDL4.0.91 and YDL6 is that the YDL4.0.91 system is the YDL4.0.91 system is 
context switching about 7000 per interval, whereas the YDl6 system is context switching about 1200 times per interval.
  I've been talking somewhat with Owen Stampflee (works for the distro maker, TSS) and have rebuilt the kernel on 
the 2.6 box removing some of the things that I don't need on my box (cell support, etc).  There did seem (subjectively)
to be a slight improvement after that.  When I get some more time to play at home I'm going to take the 2.6.13 .config
I use and build a 2.6.23 kernal using 'make oldconfig' and try to figure if it is a config issues.
  I realize that going from 2.6.13 to 2.6.23 is a *huge* change, and that the problems may not be tied to the kernel
but to other things, but are there any other suggestions folks have for finding the cause of the performance slowdown?

Thank you...


Rob
