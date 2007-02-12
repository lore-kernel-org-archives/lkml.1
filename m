Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbXBLSTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbXBLSTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965032AbXBLSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:19:09 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:32855 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014AbXBLSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:19:09 -0500
Message-ID: <45D0AF9A.509@s5r6.in-berlin.de>
Date: Mon, 12 Feb 2007 19:19:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de> <p73abzji9xi.fsf@bingen.suse.de> <200702121737.12882.fink@mpe.mpg.de>
In-Reply-To: <200702121737.12882.fink@mpe.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin A. Fink wrote:
> This means, that the CPU is only 7.3 of 52.8 seconds working.
...
> It looks like 
> the SATA driver simply blocks the CPU while doing whatever...

The system sleeps while waiting for the disk (actually, for the SATA
host port) to be done with its work.

As Andi explained, if the system gives the disk a small task, waits for
the task to be completed, then gives it a next task and so on, latencies
add up and eat into effective bandwidth. Give the disk a whole set of
tasks so that
  - it has immediately something new to do when it finished one task,
  - deep pipes are not mostly empty due to "bubbles" in the pipe,
  - tasks can be reordered to be executed in optimized manner for good
    bandwidth utilization (if software/ firmware/ hardware is present
    which supports this; e.g. the Linux kernel itself),
etc.
Also make each task large so that the ratio of protocol overhead to net
data payload stays minimal.
-- 
Stefan Richter
-=====-=-=== --=- -==--
http://arcgraph.de/sr/
