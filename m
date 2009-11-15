Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZKOSs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZKOSs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZKOSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:48:26 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:32516 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZKOSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:48:26 -0500
Message-ID: <4B004C87.7010406@oracle.com>
Date: Sun, 15 Nov 2009 10:46:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kzak@redhat.com
Subject: mmotm-1113: efi.c:  __divdi3 undefined (i386)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B004CE4.010B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on i386 builds:

fs/built-in.o: In function `last_lba':
efi.c:(.text+0x9d9fe): undefined reference to `__divdi3'


-       return (bdev->bd_inode->i_size >> 9) - 1ULL;
+       return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;

-- 
~Randy
