Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZFNIav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZFNIav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 04:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZFNIaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 04:30:35 -0400
Received: from mail-fx0-f207.google.com ([209.85.220.207]:33189 "EHLO
	mail-fx0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbZFNIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 04:30:28 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 04:30:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dCCdw/ZeFsXNoUcfFTFsj7gyhcp4f0tvb6OvGNzZTPsmmd/gIeIFzmuM43JzPe0OmB
         Y+ykJt7E701zieMUYOYqBiN5LZZdAEU7ZBcoGu0MUdin1SfrkUA0G3+MyiU1JVlUi3B6
         xD3bTXKivzI2sLFq9XkjcIwacqPIeY86PxjZo=
Message-ID: <4A34B2FD.20701@gmail.com>
Date: Sun, 14 Jun 2009 10:21:17 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 04/14] Pramfs: Mounting as root filesystem
References: <4A33A7D7.3040008@gmail.com> <200906140104.43463.arnd@arndb.de>
In-Reply-To: <200906140104.43463.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Saturday 13 June 2009, Marco wrote:
>>  void __init mount_root(void)
>>  {
>> +#ifdef CONFIG_ROOT_PRAMFS
>> +       if (MAJOR(ROOT_DEV) == MEM_MAJOR) {
>> +               if (mount_pramfs_root())
>> +                       return;
>> +
>> +               printk(KERN_ERR "VFS: Unable to mount root fs via PRAMFS, trying floppy.\n");
>> +               ROOT_DEV = Root_FD0;
>> +       }
>> +#endif
> 
> AFAICT, this will prevent booting from /dev/ram0 with a regular file system,
> because that also uses MAJOR(ROOT_DEV) == 1.
> 
> 	Arnd <><
> 

Mmm...MEM_MAJOR and RAMDISK_MAJOR have the same value and pramfs works
in memory. We could simply use /dev/null (there was an error in the
submitted kconfig description, my intention was to use /dev/mem). In
that case I can use UNNAMED_MAJOR. PRAMFS root option is not enabled if
it's already enabled the NFS one. What do you think?

Marco
