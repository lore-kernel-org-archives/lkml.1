Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZDGODw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZDGODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZDGODm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:03:42 -0400
Received: from exc02vs1.exchange.cysonet.com ([85.158.200.84]:26591 "EHLO
	exc02vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbZDGODm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:03:42 -0400
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Tue, 07 Apr 2009 16:03:38 +0200
Subject: RE:    [PATCH 0/7] Per-bdi writeback flusher threads
From: Jos Houtman <jos@hyves.nl>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Message-ID: <C60129DA.EB0F%jos@hyves.nl>
Thread-Topic: [PATCH 0/7] Per-bdi writeback flusher threads
Thread-Index: Acm3iaX9xiZvai4UaUmZ2/HKNifSgA==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2009 14:03:39.0832 (UTC) FILETIME=[A714A380:01C9B789]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tried the write-back branch from the 2.6-block tree.

And I can atleast confirm that it works, atleast in relation to the
writeback not keeping up when the device was congested before it wrote a
1024 pages. 

See: http://lkml.org/lkml/2009/3/22/83  for a bit more information.


But the second problem seen in that thread, a write-starve-read problem does
not seem to solved. In this problem the writes of the writeback algorithm
starve the ongoing reads, no matter what io-scheduler is picked.

For good measure I also applied the blk-latency patches on top of the
writeback branch, this did not improve anything. Nor did lowering
max_sectors_kb, as linus suggested in the IO latency thread.


As for a reproducible test-case: the simplest I could come up with was
modifying the fsync-tester not to fsync, but letting the normal writeback
handle it. And starting a separate process that tries to sequentially read a
file from the same device. The read performance drops to a bare minimum as
soon as the writeback algorithm kicks in.


Jos





