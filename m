Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbXBCUXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbXBCUXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbXBCUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:23:49 -0500
Received: from mail.nagafix.co.uk ([194.145.196.85]:39634 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXBCUXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:23:48 -0500
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 15:23:48 EST
Message-ID: <45C4EA2F.2060509@nagafix.co.uk>
Date: Sat, 03 Feb 2007 20:01:51 +0000
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: APIC Oops on 2.6.19.1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Matt Mackall said:
"So yes, if a user reports a bug that's attributable to a single bit 
memory error that's otherwise unreproduced and unexplained, it's totally 
reasonable to chalk it up to cosmic rays until some sort of pattern of 
reports emerges."

So I guess that the only way to figure out if this is indeed a one-off 
cosmic ray is to post it somewhere public in case someone else sees it?
As there is no APIC mailing list, I am posting to LKML - sorry for the 
line noise, feel free to tell me to post elsewhere (/dev/null?).


Here it is: on a Dual-Opteron Tyan board which is rebooting every hour 
to run some unit tests, I caught this -only once- at boot (partially 
copied by hand):

Pid: 1, comm: swapper Not tainted 2.6.19.1 #1
RIP: 0010:[<ffffffff80272dba>] [<ffffffff80272dba>] 
setup_APIC_timer+0x1e/0xba
RSP: 0000:ffff81007ffa7ec0  EFLAGS: 00000002
RAX: ....


CS: 0010 DS: 0018 ES: 0018 CR0: 0000000000008005003b
CR2: 000000000000000 CR3: 0000000000201000 CR4: 0000000000006e0
Process swapper: (pid: 1, threadinfo fffff81007ffa6000, task 
ffff8100023937a0)
Stack: 000000000be41ca0 ffffffffff806491bc 0000000000000000 000040b400090000
  000000000008e000 000000000090000 0000000000008e000 ffffffffffff80267297
  0000000000000000 fffffff80546280 fffffffff80261a61 00000000000000000000
Call Trace:
  [<ffffffff806491bc>] setup_boot_APIC_clock+0x115/0x11d
  [<ffffffff80267297>] init+0x48/0x306
  [<ffffffff8025bed8>] child_rip+0xa/0x12


Code: 8b 04 25 f0 e0 5f ff 39 d0 73 f5 8b 04 25 f0 e0 5f ff 39 d0
  <0>Kernel panic - not syncing: Attempting to kill init!

