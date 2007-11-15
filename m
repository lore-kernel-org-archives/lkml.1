Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbXKOVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbXKOVmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763934AbXKOVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:42:04 -0500
Received: from twin.jikos.cz ([213.151.79.26]:44424 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXKOVmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:42:01 -0500
Date: Thu, 15 Nov 2007 22:41:41 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <20071115192319.GA30186@kroah.com>
Message-ID: <Pine.LNX.4.64.0711152238180.19853@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
 <20071114083906.178232cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
 <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz> <20071114181948.GA15240@kroah.com>
 <20071115192319.GA30186@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Greg KH wrote:

> This patch, as found by Dave Young, should fix the issue: I'll roll it 
> into my larger patchset so that Andrew will get it automatically next 
> release, but here it is for people to use now.

Hmm, something strange going on here. With this patch applied on top of 
2.6.24-rc2-mm1, I can't see no lockup or warning from kobjects code, which 
is good. But this happens:

...
Creating device nodes with udev
resume device  not found (ignoring)
Waiting for device 
/dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6 to appear:  
ok
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
fsck 1.40.2 (12-Jul-2007)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a 
/dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6
Error writing block 1542 (Attempt to write block from filesystem resulted 
in short write).

/dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6: UNEXPECTED 
INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)
Error writing block 1542 (Attempt to write block from filesystem resulted in short write).                                                                                         

(and this keeps looping forever).

However the very same kernel, with the very same .config, but with just 

	gregkh-driver-kset-convert-block_subsys-to-use-kset_create
	gregkh-driver-kobject-remove-subsystem_register-functions
	gregkh-driver-kset-remove-decl_subsys-macro

reverted, boots perfectly fine.

-- 
Jiri Kosina
