Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXE3KyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXE3KyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXE3Kxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:53:53 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:4321 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXE3Kxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:53:52 -0400
Date: Wed, 30 May 2007 12:53:51 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc2-mm1 REVIEW] sysfs: make directory
 dentries/inodes reclaimable
Message-ID: <20070530125351.2002a316@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11803701861778-git-send-email-htejun@gmail.com>
References: <11803701861778-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 01:36:26 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Please review, test, scream... :-)

Kernel seems a bit unhappy:

BUG: sleeping function called from invalid context at
include/asm/uaccess.h:234 in_atomic():1, irqs_disabled():0
00000000018b8d80 0000000000000002 0000000000000000 00000000030c3d68 
       00000000030c3ce0 00000000003aa006 00000000003aa006 0000000000015528
       0000000000000000 000003ffffb15750 00000000018b8d80 0000000000000000
       000000000046de20 0000000000000000 00000000030c3d30 ffffffff0000000e
       0000000000333fb0 0000000000015572 00000000030c3cc8 00000000030c3d10
Call Trace:
([<00000000000154bc>] show_trace+0xbc/0xd0)
 [<0000000000031a6e>] __might_sleep+0xfe/0x158
 [<00000000000b6836>] filldir+0xf6/0x198
 [<0000000000103a82>] sysfs_readdir+0x10a/0x228
 [<00000000000b6220>] vfs_readdir+0xb8/0xd8
 [<00000000000b63e8>] sys_getdents+0x60/0xdc
 [<00000000000222c0>] sysc_noemu+0x10/0x16
 [<00000200000de78e>] 0x200000de78e

But at least it comes up :)

(Will take a look at the patches now)
