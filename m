Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYAQKht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYAQKht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYAQKhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:37:41 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:39189 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbYAQKhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:37:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5FABe/jkfVcsfHRmdsb2JhbACBWIYHh0JsAQEBNwGdaw
Message-ID: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
Date: Thu, 17 Jan 2008 11:19:07 +0100 (CET)
Subject: SCHED_FIFO & system()
From: linux@sundmangroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
I have some strange behavior in one of my systems.

I have a real-time kernel thread under SCHED_FIFO which is running every
10ms.
It is blocking on a semaphore and released by a timer interrupt every 10ms.
Generally this works really well.

However, there is a module in the system that makes a / system() / call
from c-code in user-space;

  system("run_my_script");

By calling and running a bash script. Independent of how the actual
script looks like the real time kernel thread does not get scheduled under
the time of 80ms -- the time it takes for the system() call to finish.

I can see when running a LTT session that the wake_up event occurs for
the real time thread 10ms into the system call but nevertheless the real
time kernel thread does not get scheduled.

The thread that calls system("run_my_script") is configured as SCHED_OTHER.

The Kernel is 2.6.21.


Anybody who recognize this or similar situations?



Cheers // Matias
