Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZJHDIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZJHDIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 23:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbZJHDIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 23:08:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35391 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZJHDIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 23:08:38 -0400
Date: Wed, 7 Oct 2009 20:08:28 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pidns memory leak
Message-ID: <20091008030828.GA18973@us.ibm.com>
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACAFD6A.3060008@fr.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still digging through some traces, but below I have some questions that 
I am still trying to answer.

>
> I am not sure what you mean by 'struct pids' but what I observed is:

Ok, I see that too. If pids leak, then pid-namespace will leak too.
Do you see any leaks in proc_inode_cache ?

>
> pid_2 and pid_namespace (as they are named in /proc/slabinfo) are never  
> decremented.
>
>> And the pid_namespace does not seem to reproduce for me, with out the
>> 'ls -al /proc/...' above, or with the simpler 'ns_exec' approach to
>> creating pid namespace.
>
> I tried to write a simpler program but I failed to reproduce it.
>
>> I am going through the code for lxc-execute, but does it remount /proc  
>> in the container ?
>
> Right, the parent does a clone(NEWMNT|NEWPID|NEWIPC|NEWUTS), wait for  
> the child while this one (pid 1) 'execs' the lxc-init process. This  
> program mounts /proc and fork-exec the command passed as parameter (here  
> 'sleep 3600').
>
> Without this intermediate process, the leak *seems* not happening.
>
> If you don't access /proc/<pid>/<file>, the leak is not happening.

I could not see the code for that.  Does lxc-stop unmount /proc too ?
Or is the umount expected to happen automatically after all processes
in the container are killed ?

Sukadev
