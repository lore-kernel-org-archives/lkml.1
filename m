Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbXEWSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbXEWSIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbXEWSIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:08:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29828 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762006AbXEWSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C5myasVFhhya/GHF59MaxAZropV1cUvBgYQahzEsMF+qJMV28MXFSgKSbAfOeUSqNxLt28g2w77DXPNJy3hjxNNZ4kaPNBtnnZ7t8aobeRydwUxbgi7ZWb81k1NNp0RzxfTB1dcRqOx0gz4MOCvjON9MLKSbckDzi1UjdfC3k6I=
Subject: [RFC 5/5] inode reservation v0.1 (next step working)
From: coly <colyli@gmail.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 02:08:52 +0800
Message-Id: <1179943732.4179.56.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the benchmark and the experimental inores patch on ext4, it can be
found that inode reservation on ext4 is a good idea to be tried. 

One of the original idea of inode reservation is NOT modifying on-disk
format. Current magic inode can make it, but use a magic inodes list to
link each reserved inode block together is not a good idea. Indeed, this
is a performance killer.

1, Therefor, group descriptor has to be modified to add a new member ---
this new member records the lastest reserved inode in inode table of
each block group.

2, Use rest room in magic inode (sizeof(ext4_inode) -
sizeof(ext4_magic_inode)) to record other reserved inode blocks. This
method can reduce number of magic inodes, which can minimize I/O for
magic inodes.

3, Use magic inode cache. Most of the magic inode accessings are reading
(not writing), therefore, caching can help to reduce most of the read
I/O for magic inode.

4, Modify mke2fs to support new on-disk layout for inode reservation.


Coly

