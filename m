Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbZCYPON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbZCYPON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZCYPN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:13:57 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:62602 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZCYPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:13:57 -0400
Message-ID: <49CA48A0.6000404@oracle.com>
Date: Wed, 25 Mar 2009 08:07:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: coly.li@suse.de
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-03-23-22-34 uploaded (reiserfs)
References: <200903240539.n2O5d6A8018954@imap1.linux-foundation.org> <49C9483B.1030905@oracle.com> <49C9C163.8040502@suse.de>
In-Reply-To: <49C9C163.8040502@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49CA49EE.00DD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li wrote:
> Hi Randy,
> 
> Randy Dunlap Wrote:
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-03-23-22-34 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>>
>>> It contains the following patches against 2.6.29-rc8:
>>
>>> fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
>> fs/built-in.o: In function `reiserfs_statfs':
>> super.c:(.text+0x7332b): undefined reference to `crc32_le'
>> super.c:(.text+0x7333f): undefined reference to `crc32_le'
>>
> Hmm, it should not be. The v2 patch includes linux/crc32.h, and I tested without
> any error. Now I am downloading mmotm to verify.

CONFIG_CRC32=m

Since reiserfs is built into the kernel image (CONFIG_REISERFS=y),
CONFIG_CRC32 also needs to be =y.
Probably just add
	select CRC32
	select BITREVERSE
to the REISERFS_FS kconfig entry.

> BTW, from series file of mmotm, I see two version patches,
> fs-reiserfs-return-f_fsid-for-statfs2.patch
> fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
> are all included. I suspect whether this is a proper behavior.

The v2 patch mostly replaces the first one.  I don't see a
problem with them.

-- 
~Randy
