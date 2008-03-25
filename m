Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYCYQdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYCYQdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYCYQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:33:42 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:27096 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYCYQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:33:41 -0400
Message-ID: <47E91EE2.9080801@emc.com>
Date: Tue, 25 Mar 2008 11:48:50 -0400
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org> <47E8FF58.8050209@rtr.ca> <47E90CDA.600@emc.com> <20080325153423.GD16721@parisc-linux.org>
In-Reply-To: <20080325153423.GD16721@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_BODY_PROD_1+ -3, EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Matthew Wilcox wrote:
> On Tue, Mar 25, 2008 at 10:31:54AM -0400, Ric Wheeler wrote:
>> I think that there are many embedded applications (lots of them linux based)
>> which have large amounts of storage behind low power, low cost 32 bit CPU's.
>>
>> Think of the home/small office NAS boxes that you can get from bestbuy or 
>> other big box stores. Those devices today have 4 S-ATA drives (each of 
>> which can be 1TB in size).
>>
>> Also, if you have a very low end box, it can still access really large 
>> storage
>> over iSCSI or a SAN which will present as a local, large device.
> 
> Don't those devices run into trouble with fsck?  The amount of memory
> you need to fsck a device is obviously going to depend on the filesystem,
> but it has to grow with device size, and I'm not sure that 4GB is enough
> virtual address space to fsck 2TB.

Absolutely - they more or less hit a stonewall once the disk has any trouble and 
you need to fsck.  On the other hand, this might be merciful since on 64 bit 
boxes, we will let you run the fsck and watch it run for a week or so before you 
despair ;-)

On a serious note, fsck time tends to track more the number of active inodes, so 
you can fsck a large file system if you use it to store large files (especially 
if you use a file system with dynamic inode creation or something like the 
uninitialized ext4 inodes).

ric

