Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXAaKnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXAaKnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932977AbXAaKnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:43:13 -0500
Received: from paragon.brong.net ([66.232.154.163]:50612 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbXAaKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:43:12 -0500
Date: Wed, 31 Jan 2007 21:42:48 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Lord <lkml@rtr.ca>,
       Bron Gondwana <brong@fastmail.fm>, Mike Houston <mikeserv@bmts.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <smfltc@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, samba-technical@lists.samba.org,
       Vladimir Saveliev <vs@namesys.com>, reiserfs-dev@namesys.com,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com
Subject: Reiserfs and MMAP (was: How many people are using 2.6.16?)
Message-ID: <20070131104248.GA14260@brong.net>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de> <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org> <20070131070237.GT3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131070237.GT3754@stusta.de>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 08:02:37AM +0100, Adrian Bunk wrote:
> reiserfs:
> commit de14569f94513279e3d44d9571a421e9da1759ae
>   [PATCH] resierfs: avoid tail packing if an inode was ever mmapped
> backport to 2.6.16 required

Which would explain the "notail" I've been careful to cargo-cult
into every mount string since I started at this job, even though
we're storing mainly very small files.

Referring back to: <43BE1EDF.3010305@namesys.com> (which went
to reiserfs-dev and a couple of the ever-growing CC list above)
we're still not 100% sure if it's safe to remove the patch that
I attached there:

>>>>--- file.c~ 2004-10-02 12:29:33.223660850 +0400
>>>>+++ file.c 2004-10-08 10:03:03.001561661 +0400
>>>>@@ -1137,6 +1137,8 @@
>>>>return result;
>>>>  }
>>>>
>>>>+    return generic_file_write(file, buf, count, ppos);
>>>>+
>>>>  if ( unlikely((ssize_t) count < 0 ))
>>>>      return -EINVAL;

which Hans asserted was about 5% slower than the resierfs custom
write implementation, but we countered at least meant that we
didn't crash in a steaming pile of processes stuck in D state
with no way out every few days.

It doesn't apply against 2.6.19 any more, which may be a good
sign.  I haven't seen anything in the changelogs that jumped
out at me as the fix though.

Regards,

Bron.
