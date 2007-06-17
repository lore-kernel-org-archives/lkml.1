Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXFQV2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXFQV2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFQV2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:28:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:49822 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbXFQV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OJmumnJi5bBgeFl64SL6hkiN0u2jrWAqPvRMXlQdY/2u1da8ZXt8qx8Y3TTYQCHLu0bJ1TAOQr8GDmKonilUuzMbFHOgUOb3nG8bM/zNAB8oYnO2lOntl1WSSAeF52J1hcuRRpFvwzY2FpNBmISOKbtPNLIP8TX/TezChrmERKs=
Message-ID: <9c21eeae0706171428u5a9ff79rad2b2083d3436d7f@mail.gmail.com>
Date: Sun, 17 Jun 2007 14:28:28 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: fuse-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: FS block count, size and seek offset?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at various file systems and how they return
stat.st_blocks and stat.st_size for directories and had some questions
on how a fuse filesystem is supposed to implement readdir with the
seek offset when trying to union two directories together.

Is the offset a byte offset into the DIR *dp? or is it the struct
dirent size (which is relative based on the name of the file) into the
dir pointer?

Also, if you want to be accurate when you stat a directory that's
unioned in the fuse file system how many blocks should one return?
Since each filesystem seems to return different values for size and
number of blocks for directories. I know I could just say that its not
supported with my filesystem built using fuse... but I'd like to at
least try to be accurate.

Is it accurate to assume that the size or number of blocks returned
from a stat will be used to pass a seek offset?

When does fuse use the seek offset?

These are the number of blocks and size on an empty dir.
ext3
size 4096 nblocks 8
reiserfs
size 48 nblocks 0
jfs
size 1 nblocks 0
xfs
size 6 nblocks 0

Any help to figure out how to union two directories and return correct
values would be helpful.

Thanks,
- David Brown

P.S. maybe a posix filesystem interface manual would be good?
