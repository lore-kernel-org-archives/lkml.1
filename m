Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZLTKER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZLTKER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZLTKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:04:16 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36721 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZLTKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:04:15 -0500
Message-ID: <4B2DF699.3090107@in.ibm.com>
Date: Sun, 20 Dec 2009 15:34:09 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: CPU offline/online related hang with latest git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.33-rc1-git1 (dd59f6c..) i am having trouble with
CPU hotplug on multiple architectures. Trying to offline
a CPU results in a machine hang.

Sample o/p from a 4 way x86_64 box :

#:/sys/devices/system/cpu/cpu3 # cat online
1
#:/sys/devices/system/cpu/cpu3 # echo 0 > online
Stack:
Call Trace:
 <IRQ>
 <EOI>
Code: 45 f0 48 89 45 b8 48 8d 45 d0 4c 89 4d f8 c7 45 b0 10 00 00 00 48 89 45 c0 e8 5a ff ff ff c9 c3 89 f0 b9 40 00 00 00 55 99 f7 f9 <48> 89 e5 48 89 f9 48 83 ec 08 31 d2 41 89 c0 eb 12 48 8b 01 48
Stack:
Call Trace:
Code: 20 00 00 00 00 48 89 3e 49 8d 74 24 28 e8 45 75 1d 00 49 c7 44 24 50 00 00 00 00 48 8b 9b 60 01 00 00 48 85 db 0f 85 25 ff ff ff <5b> 41 5c c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 81 ec
Stack:
Call Trace:
Code: 48 0f 45 d8 eb 1a 44 0f a3 20 19 c0 48 c7 c3 10 b5 a0 81 85 c0 48 c7 c0 30 b5 a0 81 48 0f 44 d8 31 c0 f3 90 44 8b 25 82 35 96 00 <41> 39 c4 74 46 41 83 fc 02 74 08 41 83 fc 03 75 12 eb 03 fa eb
Stack:
Call Trace:
Code: 48 c7 c0 30 b5 a0 81 48 0f 45 d8 eb 1a 44 0f a3 20 19 c0 48 c7 c3 10 b5 a0 81 85 c0 48 c7 c0 30 b5 a0 81 48 0f 44 d8 31 c0 f3 90 <44> 8b 25 82 35 96 00 41 39 c4 74 46 41 83 fc 02 74 08 41 83 fc
Uhhuh. NMI received for unknown reason 25 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue

The above messages are repeated after this. I observed similar hangs
on other architectures as well (s390x, PowerPC, x86_32).

2.6.33-rc1 worked fine. I haven't tried the bisect. Will do that
first thing tomorrow morning. 

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

