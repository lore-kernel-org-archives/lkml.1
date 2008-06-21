Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYFUKfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYFUKfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYFUKfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:35:16 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:58268 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYFUKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V6mOxcSFtSOv9YcAQag6g09/XT4Dvmb72smpz3te+JwQ+2GRjP5nJJQf8NU7ufzxH0
         CAU5ka6Cf0eZh61TthO+PpdL928r/3CJV9oaDzLh8RqTi55EfBdILKgtM5aqgHCWBC6D
         4H/C2y7xBjywqTdsW4C2jT3kQRW5217JhF3w0=
Message-ID: <485CD956.3070209@gmail.com>
Date: Sat, 21 Jun 2008 12:35:02 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, axboe@kernel.dk,
       matt@bluehost.com, roberto@unbit.it, Divyesh Shah <dpshah@google.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
References: <1213956335-29866-2-git-send-email-righi.andrea@gmail.com> <20080620100825.eff22c44.randy.dunlap@oracle.com>
In-Reply-To: <20080620100825.eff22c44.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Randy, I've applied all your fixes to my local documentation,
next patchset version will include them. A few small comments below.

Randy Dunlap wrote:
>> +* Run a benchmark doing I/O on /dev/sda1 and /dev/sda5; I/O limits and usage
>> +  defined for cgroup "foo" can be shown as following:
>> +  # cat /mnt/cgroup/foo/blockio.bandwidth
>> +  === device (8,1) ===
>> +    bandwidth limit: 1024 KiB/sec
>> +  current i/o usage: 819 KiB/sec
>> +  === device (8,5) ===
>> +    bandwidth limit: 1024 KiB/sec
>> +  current i/o usage: 3102 KiB/sec
> 
> Ugh, this makes it look like the output does "pretty printing" (formatting),
> which is generally not a good idea.  Let some app be responsible for that,
> not the kernel.  Basically this means don't use leading spaces just to make the
> ":"s line up in the output.

Sounds reasonable. I think the output could be further reduced,
the following format should be explanatory enough.

device: %u,%u
bandwidth: %lu KiB/sec
usage: %lu KiB/sec

>> +WARNING: per-block device limiting rules always refer to the dev_t device
>> +number. If a block device is unplugged (i.e. a USB device) the limiting rules
>> +associated to that device persist and they are still valid if a new device is
> 
> associated with (?)

what about:

...the limiting rules defined for that device...

-Andrea
