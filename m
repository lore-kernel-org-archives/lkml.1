Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYBOSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYBOSY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYBOSYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:24:48 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42309 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbYBOSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:24:46 -0500
Date: Fri, 15 Feb 2008 10:44:50 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] SCSI: fix data corruption caused by ses v2
In-reply-to: <1203090786.3058.22.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200802151044.51586.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802131625.17172.yinghai.lu@sun.com>
 <1203090786.3058.22.camel@localhost.localdomain>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 07:53:06 am James Bottomley wrote:
> On Wed, 2008-02-13 at 16:25 -0800, Yinghai Lu wrote:
> > one system: initrd get courrupted:
> > 
> > RAMDISK: Compressed image found at block 0
> > RAMDISK: incomplete write (-28 != 2048) 134217728
> > crc error
> > VFS: Mounted root (ext2 filesystem).
> > Freeing unused kernel memory: 388k freed
> > init_special_inode: bogus i_mode (177777)
> > Warning: unable to open an initial console.
> > init_special_inode: bogus i_mode (177777)
> > init_special_inode: bogus i_mode (177777)
> > Kernel panic - not syncing: No init found.  Try passing init= option to kernel.
> > 
> > bisected to
> > commit 9927c68864e9c39cc317b4f559309ba29e642168
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Sun Feb 3 15:48:56 2008 -0600
> > 
> >     [SCSI] ses: add new Enclosure ULD
> > 
> > changes:
> > 1. change char to unsigned char to avoid type change later.
> > 2. preserve len for page1
> > 3. need to move desc_ptr even the entry is not enclosure_component_device/raid.
> >    so keep desc_ptr on right position
> > 4. record page7 len, and double check if desc_ptr out of boundary before touch.
> > 5. fix typo in subenclosure checking: should use hdr_buf instead.
> > 
> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> OK, I added this with a fixup to eliminate the spurious goto
> 

good
