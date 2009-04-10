Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbZDJF1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbZDJF1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZDJF1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:27:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:36697 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbZDJF1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:27:22 -0400
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <910A25D6-E6E6-4742-B9F4-52532D92117D@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
In-Reply-To: <20090410010319.GA2354@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible ptrace issue?)
Date: Fri, 10 Apr 2009 00:24:56 -0500
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com> <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org> <20090409213910.GB30645@us.ibm.com> <B6C30A35-DBF7-4710-9F03-9E42775CDA21@kernel.crashing.org> <20090410010319.GA2354@us.ibm.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 8:03 PM, Sukadev Bhattiprolu wrote:

>>
>> -bash-3.2# ps
>> PID TTY          TIME CMD
>> 2289 ttyS0    00:00:00 bash
>> 2310 ttyS0    00:00:00 runltp
>> 2412 ttyS0    00:00:00 pan
>> 2448 ttyS0    00:00:00 recv01 <defunct>
>> 2450 ttyS0    00:00:00 recvfrom01 <defunct>
>> 2452 ttyS0    00:00:00 recvmsg01 <defunct>
>> 2473 ttyS0    00:00:00 rename14
>> 2474 ttyS0    00:00:01 rename14
>> 2477 ttyS0    00:00:00 rename14
>> 2481 ttyS0    00:00:00 ps
>> -bash-3.2# cat /proc/1/status
>> Name:   init
>> State:  T (stopped)
>
> init is in the stopped state.  Can you run "kill -CONT 1" ?

yes

>> Tgid:   1
>> Pid:    1
>> PPid:   0
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> FDSize: 32
>> Groups:
>> VmPeak:     1948 kB
>> VmSize:     1944 kB
>> VmLck:         0 kB
>> VmHWM:       648 kB
>> VmRSS:       648 kB
>> VmData:      164 kB
>> VmStk:        84 kB
>> VmExe:       288 kB
>> VmLib:      1124 kB
>> VmPTE:        20 kB
>> Threads:        1
>> SigQ:   8/16384
>> SigPnd: 0000000000000000
>> ShdPnd: 0000000000010000
>
> Init does have the pending SIGCHLD, so the zombies should go away
> when init gets the SIGCONT.

That seems to clear it up.. But why has the behavior changed?  I  
didn't have to do the "kill -CONT 1" on 2.6.29.

- k
