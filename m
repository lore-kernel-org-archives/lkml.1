Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZJHINE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZJHINE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZJHINE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:13:04 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:41087 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZJHINB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:13:01 -0400
Message-ID: <4ACD9ECC.90508@fr.ibm.com>
Date: Thu, 08 Oct 2009 10:11:56 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pidns memory leak
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com> <20091008030828.GA18973@us.ibm.com>
In-Reply-To: <20091008030828.GA18973@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Still digging through some traces, but below I have some questions that 
> I am still trying to answer.
> 
>> I am not sure what you mean by 'struct pids' but what I observed is:
> 
> Ok, I see that too. If pids leak, then pid-namespace will leak too.
> Do you see any leaks in proc_inode_cache ?

Yes, right. It leaks too.

>> pid_2 and pid_namespace (as they are named in /proc/slabinfo) are never  
>> decremented.
>>
>>> And the pid_namespace does not seem to reproduce for me, with out the
>>> 'ls -al /proc/...' above, or with the simpler 'ns_exec' approach to
>>> creating pid namespace.
>> I tried to write a simpler program but I failed to reproduce it.
>>
>>> I am going through the code for lxc-execute, but does it remount /proc  
>>> in the container ?
>> Right, the parent does a clone(NEWMNT|NEWPID|NEWIPC|NEWUTS), wait for  
>> the child while this one (pid 1) 'execs' the lxc-init process. This  
>> program mounts /proc and fork-exec the command passed as parameter (here  
>> 'sleep 3600').
>>
>> Without this intermediate process, the leak *seems* not happening.
>>
>> If you don't access /proc/<pid>/<file>, the leak is not happening.
> 
> I could not see the code for that.  Does lxc-stop unmount /proc too ?
> Or is the umount expected to happen automatically after all processes
> in the container are killed ?

The umount is expected to happen automatically. I can not access the 
container from the outside to umount /proc.
