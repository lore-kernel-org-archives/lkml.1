Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXH3OpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXH3OpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761833AbXH3Oo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:44:29 -0400
Received: from mi1.bluebottle.com ([206.188.25.14]:46112 "EHLO
	mi1.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761810AbXH3Oo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:44:28 -0400
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:message-id:from:to:subject:date:mime-version:
	content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:x-mailer:x-mimeole:x-trusted-delivery;
	b=jnwDULJyUZyG8zGYWStEjsP7P5KZj/lx3EdcfKU27OklhFFMFLXjbdAdIVMWuMe8P
	Lf9N8e6/iPVzT3eTnDQmIBCdsgIuPMRK4MTHuNEze4aBMS8foekD5mBzYBLiIKn
Message-ID: <002d01c7eb14$4b18fab0$0100a8c0@hak>
From: "n" <xellos@bluebottle.com>
To: <linux-kernel@vger.kernel.org>
Subject: Bug? Realtek RTL-8169 Gigabit Ethernet  and High Resolution Timers
Date: Thu, 30 Aug 2007 07:44:38 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Trusted-Delivery: <34a6fd25be425b3e23aad1e9df483624>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found a bug when using the Ethernet controller: Realtek Semiconductor Co., 
Ltd. RTL-8169 Gigabit Ethernet (rev 10)  ethernet card and kernel High 
Resolution Timers (menuconfig -> Processor type and features -> High 
Resolution Timer Support )
after about 20 kernel compiles i finnaly figured out this option was making 
the ethernet card slow
tested kernels 2.6.22,2.6.22.5, 2.6.23-rc4 (running now)

the cpu is the pc is a p3 667 mhz so its cpu limited i guess and maxes at 
400mbit~. (without High Resolution Timers )
with High Resolution Timers off it would only do 50-70mbit.

r8169 (compile as module + napi)
High Resolution Timer Support (enabled)
tested with iperf also system is very unresponsive i cant even open a ssh 
session or type a command while the test ran
[  5]  0.0-10.0 sec  64.5 MBytes  54.0 Mbits/sec

r8169 (compile as module + napi)
High Resolution Timer Support (disabled)
[  3]  0.0-10.0 sec    552 MBytes    463 Mbits/sec

as you can see with it disabled the speed really improved.
but im wondering what does High Resolution Timer's do and what does it have 
to do with a pci gigabit ethernet card that would slow it down
maybe someone else could test and see if they get the same results

this might solve alot of problems with this card since alot of distros 
compile Resolution Timer default to enabled...

----------------------------------------------------------------------
Get a free email address with REAL anti-spam protection.
http://www.bluebottle.com/tag/1

