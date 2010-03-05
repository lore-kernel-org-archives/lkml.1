Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0CETKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:10:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48613 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755418Ab0CETKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:10:36 -0500
Message-Id: <20100305191035.058221526@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 13:10:35 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] reduce per cpu boot up messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since more complex patches were rejected, try simple patches to
reduce the boot up clutter on the console, specifically those
which are printed for each cpu.


Patch 1: limit-MCA-messages changes:

Booting Node   0, Processors  #1
CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #2
CPU 2 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #3
CPU 3 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #4
CPU 4 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #5
CPU 5 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #6
CPU 6 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21
 #7

<<< and so on for up to 4096 cpus >>>

to a less cluttered:

Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
Booting Node   2, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
...

Patch 2: change-firmware-msglevel

Change the loglevel of these messages to debug so as to not
get 4096 repititous messages.

Patch 3: remove-idle-messages

Print the "WARNING: polling idle and HT enabled, performance may degrade"
message once instead of for each cpu.

-- 
