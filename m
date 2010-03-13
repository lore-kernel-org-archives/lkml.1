Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0CMXWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 18:22:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:38203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755242Ab0CMXV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 18:21:59 -0500
X-Authenticated: #352556
X-Provags-ID: V01U2FsdGVkX1+9HhE+uNi98qIJBMVGV9Jm2fTQtOVuWkEi3adb+8
	FOTkBY5Ivau66G
Message-ID: <4B9C1E14.8070400@gmx.net>
Date: Sun, 14 Mar 2010 00:21:56 +0100
From: Joachim Otahal <Jou@gmx.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: md devices: Suggestion for in place time and checksum within the
 RAID
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Situation in RAID:
If a drive fails silently and is giving out wrong data instead of read 
errors there is no way to detect that corruption (no fun, I had that a 
few times already).
Even in RAID1 with three drives there is no "two over three" voting 
mechanism.

A workaround for that problem would be:
Adding one sector to each chunk to store the time (in nanoseconds 
resolution) + CRC or ECC value of the whole stripe, making it possible 
to see and handle such errors below the filesystem level.
Time in nanoseconds only to differ between those many writes that 
actually happen, it does not really matter how precise the time actually 
is, just every stripe update should have a different time value from the 
previous update.
It would be an easy way to know which chunks are actually the latest (or 
which contain correct data in case one out of three+ chunks has a wrong 
time upon reading). A random uniqe ID or counter could also do the job 
of the time value if anyone prefers, but I doubt since the collision 
possibility would be higher.
The use of CRC or ECC or whatever hash should be obvious, their 
existence would make it easy to detect drive degration, even in a RAID0 
or LINEAR.
Bad side: Adding this might break the on the fly raid expansion 
capabilities. A workaround might be using 8K(+ one sector) chunks by 
default upon creation or the need to specify the chunk size on creation 
(like 8k+1 sector) if future expansion capabilities are actually wanted 
with RAID0/4/5/6, but that is a different issue anyway.

Question:
Will RAID4/5/6 in the future use the parity upon read too? Currently it 
would not detect wrong data reads from the parity chunk, resulting in a 
disaster when it is actually needed.

Do those plans already exist and my post was completely useless?

Sorry that I cannot give patches, my last kernel patch + compile was 
2.2.26, since then I never compiled a kernel.

Joachim Otahal

