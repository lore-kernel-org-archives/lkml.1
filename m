Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYCaVDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYCaVDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYCaVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:02:56 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26681 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYCaVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:02:55 -0400
Date: Mon, 31 Mar 2008 15:02:52 -0600
From: Alex Chiang <achiang@hp.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080331210252.GA2362@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com> <20080331202633.GA341@ldl.fc.hp.com> <200803311652.17234.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803311652.17234.chris.mason@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason <chris.mason@oracle.com>:
> 
> Great, thanks I'll take these two.  The kernel side needs the
> same hash.c fix, but I've already got that change made locally.

Here's a patch for the kernel side.

/ac

Subject: [PATCH] btrfs: Stop trashing 'name' arg of btrfs_name_hash
From: Alex Chiang <achiang@hp.com>

In btrfs_name_hash, Local variable 'buf' is declared as

        __u32 buf[2];

but we then try to do this:

        buf[0] = 0x67452301;
        buf[1] = 0xefcdab89;
        buf[2] = 0x98badcfe;
        buf[3] = 0x10325476;

Oops. Fix buf to be the proper size.

Signed-off-by: Alex Chiang <achiang@hp.com>

diff -r e4cd88595ed7 -r 03942eecb56d hash.c
--- a/hash.c	Thu Feb 21 14:54:12 2008 -0500
+++ b/hash.c	Mon Mar 31 14:58:00 2008 -0600
@@ -81,7 +81,7 @@ u64 btrfs_name_hash(const char *name, in
 	__u32	hash;
 	__u32	minor_hash = 0;
 	const char	*p;
-	__u32		in[8], buf[2];
+	__u32		in[8], buf[4];
 	u64		hash_result;
 
 	if (len == 1 && *name == '.') {
