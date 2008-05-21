Return-Path: <linux-kernel-owner+w=401wt.eu-S937071AbYEUU3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937071AbYEUU3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbYEUU2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:28:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29665 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYEUU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:28:53 -0400
Date: Wed, 21 May 2008 13:28:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mark <markkicks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Message-Id: <20080521132845.72db5748.randy.dunlap@oracle.com>
In-Reply-To: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 11:26:47 -0700 mark wrote:

> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
> error when I try to login to the box, kill a pr start a python app, or
> do anything on a regular basis.
> 
> fork: Resource temporarily unavailable
> 
> I have over 10GB RAM free, and zero swap spaced used. The box is a
> dual quad core Intel Xeon 5405 with 16GB RAM.
> 
> There is no error message in /var/log/messages or dmesg ...
> how do I identify the problem?
> thanks!
> 
> uname -a
> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
> x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> free -m
>             total       used       free     shared    buffers     cached
> Mem:         16086       3189      12896          0         42        666
> -/+ buffers/cache:       2481      13605
> Swap:         1983          0       1983
> 
> 
> have only 505 processes running
> ps aux | wc -l
> 505
> 
> 
> uptime
>  11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87
> 
> ulimit -a
> core file size          (blocks, -c) 0
> data seg size           (kbytes, -d) unlimited
> scheduling priority             (-e) 0
> file size               (blocks, -f) unlimited
> pending signals                 (-i) 137216
> max locked memory       (kbytes, -l) 32
> max memory size         (kbytes, -m) unlimited
> open files                      (-n) 32768
> pipe size            (512 bytes, -p) 8
> POSIX message queues     (bytes, -q) 819200
> real-time priority              (-r) 0
> stack size              (kbytes, -s) 10240
> cpu time               (seconds, -t) unlimited
> max user processes              (-u) 1024
> virtual memory          (kbytes, -v) unlimited
> file locks                      (-x) unlimited

Hi,

The only place that fork() returns EAGAIN is for number of
processes being >= its limit.  Does this user already have >= 1024
processes?


---
~Randy
