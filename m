Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbZIDVe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbZIDVe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934253AbZIDVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:34:27 -0400
Received: from firenze.fesnel.com ([74.208.149.51]:43731 "EHLO
	firenze.fesnel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116AbZIDVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:34:26 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 17:34:26 EDT
Message-ID: <4AA1860B.4030409@fesnel.com>
Date: Fri, 04 Sep 2009 17:26:35 -0400
From: Mike Heffner <mikeh@fesnel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090320 Fedora/2.0.0.21-1.fc9 Lightning/0.9 Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HR timers prevent an itimer from generating EINTR?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary:

Mixing HR timers with itimers occasionally hides an EINTR from a 
blocking syscall.


Description:

In my test program I have a High Resolution timer firing every one 
second (with SA_RESTART) and I set an itimer (without SA_RESTART) to 
fire after three seconds. I then execute a blocking system call (flock 
in this case) and expect the three second itimer to interrupt the system 
call with EINTR. However, I frequently notice that the itimer will fire 
but it will not interrupt the blocking system call. There appears to be 
a race between the HR timer firing and the itimer firing. If I offset 
the HR timer frequency by a half second, the itimer always interrupts 
the system call.

Kernel version:

These kernels both demonstrate the condition:

2.6.29.6-217.2.16.fc11.x86_64
	and
2.6.30.5-43.fc11.x86_64


I do not see this condition on:

2.6.18-53.el5


Test program:

The following program illustrates this condition:

http://github.com/mheffner/scripts/commits/master/hrtimer_vs_itimer.c


Is this behavior expected?


Cheers,

Mike

-- 

   Mike Heffner   <mikeh@fesnel.com>

