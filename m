Return-Path: <linux-kernel-owner+w=401wt.eu-S937485AbYEUUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937485AbYEUUjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbYEUUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:39:33 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:5059 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764033AbYEUUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GNZsjBnjCy6z4uSQFz7Tm4LFHCb6usB0gfENa5AcUewpGmY0EuK4JkY9UQc0/XKaQONaE+dNtYLkOWxXgg9zyj4Fo3m2r39lGWwGnZNB7jWE9YzPjvOuyFtvXDNRSRjKMc8sclMK1K4Ek61hlq1wiapM9EAkesxKVzJQT+p9ofU=
Message-ID: <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
Date: Wed, 21 May 2008 13:39:30 -0700
From: mark <markkicks@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080521132845.72db5748.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:28 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
>> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
>> error when I try to login to the box, kill a pr start a python app, or
>> do anything on a regular basis.
>>
>> fork: Resource temporarily unavailable
>>
>> I have over 10GB RAM free, and zero swap spaced used. The box is a
>> dual quad core Intel Xeon 5405 with 16GB RAM.
>>
>> There is no error message in /var/log/messages or dmesg ...
>> how do I identify the problem?
>> thanks!
>>
>> uname -a
>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> free -m
>>             total       used       free     shared    buffers     cached
>> Mem:         16086       3189      12896          0         42        666
>> -/+ buffers/cache:       2481      13605
>> Swap:         1983          0       1983
>>
>>
>> have only 505 processes running
>> ps aux | wc -l
>> 505
>>
>>
>> uptime
>>  11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87
>>
>> ulimit -a
>> core file size          (blocks, -c) 0
>> data seg size           (kbytes, -d) unlimited
>> scheduling priority             (-e) 0
>> file size               (blocks, -f) unlimited
>> pending signals                 (-i) 137216
>> max locked memory       (kbytes, -l) 32
>> max memory size         (kbytes, -m) unlimited
>> open files                      (-n) 32768
>> pipe size            (512 bytes, -p) 8
>> POSIX message queues     (bytes, -q) 819200
>> real-time priority              (-r) 0
>> stack size              (kbytes, -s) 10240
>> cpu time               (seconds, -t) unlimited
>> max user processes              (-u) 1024
>> virtual memory          (kbytes, -v) unlimited
>> file locks                      (-x) unlimited
> The only place that fork() returns EAGAIN is for number of
> processes being >= its limit.  Does this user already have >= 1024
> processes?

No, it is around 400

ps ax | wc -l
417

I also I increased max process to unlimited, and I still get the error
randomly..

ulimit -u
unlimited

my webserver is now throwing this error:

setuid(500) failed (11: Resource temporarily unavailable)


cat /etc/passwd | grep mark
mark:x:500:500::/home/mark:/bin/bash

I also increased this, but still the same error
kernel.pid_max =  65536
