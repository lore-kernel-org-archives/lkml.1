Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbXK2N4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbXK2N4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbXK2N4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:56:10 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:42668 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbXK2N4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:56:09 -0500
Message-ID: <474EA914.1060502@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2007 17:27:08 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       nfs@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@in.ibm.com>,
       Jan Kara <jack@suse.cz>
Subject: Re: [BUG] 2.6.24-rc3-mm2 kernel bug on nfs & cifs mounted partitions
References: <20071128034140.648383f0.akpm@linux-foundation.org> <474E7F9E.9000601@linux.vnet.ibm.com> <20071129010906.772e0c15.akpm@linux-foundation.org>
In-Reply-To: <20071129010906.772e0c15.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 Nov 2007 14:30:14 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Hi Andrew,
>>
>> While running file system stress on nfs and cifs mounted partitions, the machine
>> drops to xmon
>>
>> 1:mon> e
>> cpu 0x1: Vector: 300 (Data Access) at [c000000080a9f880]
>>     pc: c0000000001392c8: .inotify_inode_queue_event+0x50/0x158
>>     lr: c0000000001074d0: .vfs_link+0x204/0x298
>>     sp: c000000080a9fb00
>>    msr: 8000000000009032
>>    dar: 280 
>>  dsisr: 40010000
>>   current = 0xc0000000c8e6f670
>>   paca    = 0xc000000000512c00
>>     pid   = 2848, comm = fsstress
>> 1:mon> t
>> [c000000080a9fbd0] c0000000001074d0 .vfs_link+0x204/0x298
>> [c000000080a9fc70] c00000000010b6e0 .sys_linkat+0x134/0x1b4
>> [c000000080a9fe30] c00000000000872c syscall_exit+0x0/0x40
>> --- Exception: c00 (System Call) at 000000000ff1bdfc
>> SP (ffeaed10) is in userspace
>> 1:mon> r
>> R00 = c0000000001074d0   R16 = 0000000000000000
>> R01 = c000000080a9fb00   R17 = 0000000000000000
>> R02 = c00000000060c380   R18 = 0000000000000000
>> R03 = 0000000000000000   R19 = 0000000000000000
>> R04 = 0000000000000004   R20 = 0000000000000000
>> R05 = 0000000000000000   R21 = 0000000000000000
>> R06 = 0000000000000000   R22 = 0000000000000000
>> R07 = 0000000000000000   R23 = 0000000000000004
>> R08 = 0000000000000000   R24 = 0000000000000280
>> R09 = 0000000000000000   R25 = fffffffffffff000
>> R10 = 0000000000000001   R26 = c000000082827790
>> R11 = c0000000003963e8   R27 = c0000000828275a0
>> R12 = d000000000deec78   R28 = 0000000000000000
>> R13 = c000000000512c00   R29 = c00000007b18fcf0
>> R14 = 0000000000000000   R30 = c0000000005bc088
>> R15 = 0000000000000000   R31 = 0000000000000000
>> pc  = c0000000001392c8 .inotify_inode_queue_event+0x50/0x158
>> lr  = c0000000001074d0 .vfs_link+0x204/0x298
>> msr = 8000000000009032   cr  = 24000882
>> ctr = c0000000003963e8   xer = 0000000000000000   trap =  300 
>> dar = 0000000000000280   dsisr = 40010000
>>
>>
>> The gdb output shows 
>>
>> 0xc0000000001076d4 is in vfs_symlink (include/linux/fsnotify.h:108).
>> 103      * fsnotify_create - 'name' was linked in
>> 104      */  
>> 105     static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
>> 106     {   
>> 107             inode_dir_notify(inode, DN_CREATE);
>> 108             inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
>> 109                                       dentry->d_inode);
>> 110             audit_inode_child(dentry->d_name.name, dentry, inode);
>> 111     }   
>> 112
>>
> 
> If it is reproducible can you please try reverting
> inotify-send-in_attrib-events-when-link-count-changes.patch?

Hi Andrew,

reverting the patch inotify-send-in_attrib-events-when-link-count-changes.patch, the 
bug is not reproduced.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
