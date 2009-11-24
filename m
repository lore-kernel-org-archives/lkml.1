Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZKXPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZKXPqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZKXPqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:46:52 -0500
Received: from sandeen.net ([209.173.210.139]:30349 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbZKXPqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:46:51 -0500
X-Greylist: delayed 1931 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 10:46:51 EST
Message-ID: <4B0BF866.7040004@sandeen.net>
Date: Tue, 24 Nov 2009 09:14:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Which kernel options should be enabled to find the root cause
 of	this bug?
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0911240805490.25676@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911240805490.25676@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Sat, 17 Oct 2009, Justin Piszcz wrote:
> 
>> Hello,
>>
>> I have a system I recently upgraded from 2.6.30.x and after
>> approximately 24-48 hours--sometimes longer, the system cannot write
>> any more files to disk (luckily though I can still write to /dev/shm)
>> -- to which I have
>> saved the sysrq-t and sysrq-w output:
>>
>> http://home.comcast.net/~jpiszcz/20091017/sysrq-w.txt
>> http://home.comcast.net/~jpiszcz/20091017/sysrq-t.txt

Unfortunately it looks like a lot of the sysrq-t, at least, was lost.

The sysrq-w trace has the "show blocked state" start a ways down the file,
for anyone playing along at home ;)

Other things you might try are a sysrq-m to get memory state...

>> Configuration:
>>
>> $ cat /proc/mdstat Personalities : [raid1] [raid6] [raid5] [raid4] md1
>> : active raid1 sdb2[1] sda2[0]
>>      136448 blocks [2/2] [UU]
>>
>> md2 : active raid1 sdb3[1] sda3[0]
>>      129596288 blocks [2/2] [UU]
>>
>> md3 : active raid5 sdj1[7] sdi1[6] sdh1[5] sdf1[3] sdg1[4] sde1[2]
>> sdd1[1] sdc1[0]
>>      5128001536 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]
>>
>> md0 : active raid1 sdb1[1] sda1[0]
>>      16787776 blocks [2/2] [UU]
>>
>> $ mount
>> /dev/md2 on / type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
>> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
>> proc on /proc type proc (rw,noexec,nosuid,nodev)
>> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>> udev on /dev type tmpfs (rw,mode=0755)
>> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
>> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
>> /dev/md1 on /boot type ext3 (rw,noatime)
>> /dev/md3 on /r/1 type xfs
>> (rw,noatime,nobarrier,logbufs=8,logbsize=262144)
>> rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
>> nfsd on /proc/fs/nfsd type nfsd (rw)

Do you get the same behavior if you don't add the log options at mount time?
Kind of grasping at straws here for now ...

>> Distribution: Debian Testing
>> Arch: x86_64
>>
>> The problem occurs with 2.6.31 and I upgraded to 2.6.31.4 and the problem
>> persists.
>>

...

> In addition to using netconsole, which kernel options should be enabled
> to better diagnose this issue?
> 
> Should I enable these to help track down this bug?
> 
> [ ]   XFS Debugging support (EXPERIMENTAL)
> [ ] Compile the kernel with frame pointers

The former probably won't hurt; the latter might gibe us better backtraces.

> Are there any other options that will help determine the root cause of this
> bug that are recommended?

Not that I can think of off hand ...

-Eric

> Justin.

