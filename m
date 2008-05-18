Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYERUbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYERUbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYERUax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:30:53 -0400
Received: from main.gmane.org ([80.91.229.2]:56287 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYERUaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:30:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Date: Sun, 18 May 2008 21:22:51 +0100
Message-ID: <g0q3lc$5oa$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org> <20080518021423.3dcf0ddd.akpm@linux-foundation.org> <20080518174749.GA22939@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

(I've dropped akpm because the mail server doesn't like where I'm sending
from with this address)

Greg KH wrote:

> On Sun, May 18, 2008 at 02:14:23AM -0700, Andrew Morton wrote:
>> 
>> (cc's added)
>> 
>> On Sat, 17 May 2008 12:50:24 +0000 (UTC) Sitsofe Wheeler
>> <sitsofe@yahoo.com> wrote:
>> 
>> > BUG: unable to handle kernel paging request at e6f17fac
>> > IP: [<c02604d6>] scsi_bus_uevent+0x1/0x17
>> > *pde = 2714b163 *pte = 26f17160
>> > Oops: 0000 [#1] DEBUG_PAGEALLOC
>> > last sysfs file:
>> 
>> I thought we'd already fixed this?
>
> If you want to test them out yourself, the patches are this one first:
>  
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core.current/driver-core-add-device_create_vargs-and-device_create_drvdata.patch
> and then add any one of the rest of the patches in the directory at:
>  
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core.current/
> depending on the subsystem you are having problems with.  There are 12
> different ones in there.
> 
> hope this helps,

Bad news - the patches all applied to 2.6.26-rc2 / current HEAD but the
problem remained.

The trace at the end seems slightly different though (alas I have to
transcribe):

BUG: unable to handle kernel paging request at e725ffac
IP: [<c025fdb6>] scsi_bus_uevent+0x1/0x17
*pde = 27845163 *pte = 2725f160
Oops: 0000 [#1] DEBUG_PAGEALLOC

[...]

dev_uevent
dev_uevent
kobject_uevent_env
mutex_unlock
kobject_uevent
device_add
mutex_unlock
scsi_sys_add_sdev
scsi_probe_and_add_lun
mark_held_locks
__scsi_add_device
ata_scsi_scan_host
ata_host_register
ata_pci_sff_activate_host
ata_sff_interrupt
ata_pci_sff_init_one
pci_device_probe
driver_probe_device
__driver_attach
bus_for_each_dev
driver_attach
__driver_attach
bus_add_driver
driver_register
__pci_register_driver
kernel_init
via_init
kernel_init
kernel_init
kernel_init
krenel_thread_helper

-- 
Sitsofe | http://sucs.org/~sits/

