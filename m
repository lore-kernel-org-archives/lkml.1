Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXAaJW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXAaJW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932736AbXAaJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:22:26 -0500
Received: from bay0-omc3-s2.bay0.hotmail.com ([65.54.246.202]:40961 "EHLO
	bay0-omc3-s2.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbXAaJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:22:25 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 04:22:25 EST
Message-ID: <BAY107-F3272D792DE490F17CD72169CA50@phx.gbl>
X-Originating-IP: [87.81.120.187]
X-Originating-Email: [dcb314@hotmail.com]
From: "d binderman" <dcb314@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: fs/ufs/inode.c:817: warning: array subscript is above array bounds
Date: Wed, 31 Jan 2007 09:08:16 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 31 Jan 2007 09:08:18.0267 (UTC) FILETIME=[58F9AAB0:01C74517]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello there,

I just tried to compile Linux kernel 2.6.19.2 with the
new GNU C compiler version 4.3 snapshot 20070126.

The compiler said

fs/ufs/inode.c:817: warning: array subscript is above array bounds

The source code is

        for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
            ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];

but

./include/linux/ufs_fs.h:                       __fs32  ui_db[UFS_NDADDR];/* 
0x28 data blocks */
./include/linux/ufs_fs.h:                       __fs64     
ui_db[UFS_NDADDR]; /* 112: Direct disk blocks. */

and

        __fs32  i_data[15];

and

#define UFS_NDADDR 12
#define UFS_NINDIR 3

so the kernel seems to be trying to write fifteen bytes into an array only 
twelve
bytes in size. Suggest code rework.


Regards

David Binderman

_________________________________________________________________
Find Love This New Year With match.com! http://msnuk.match.com

