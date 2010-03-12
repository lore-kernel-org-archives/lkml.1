Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0CLHB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:01:57 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:35363 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0CLHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:01:54 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: tytso@mit.edu
Subject: [PATCH resend] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
Date: Fri, 12 Mar 2010 08:01:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-self-dirty; KDE/4.3.4; x86_64; ; )
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akira Fujita <a-fujita@rs.jp.nec.com>,
       Eric Sandeen <sandeen@redhat.com>
References: <201003072132.10579.borntraeger@de.ibm.com>
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003120801.51249.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted, can you consider this patch for ext4?

From: Christian Borntraeger <borntraeger@de.ibm.com>

I have an x86_64 kernel with i386 userspace. e4defrag fails on the
EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
case. It seems that 
struct move_extent is compat save, only types with fixed widths are used.
{
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};


Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Akira Fujita <a-fujita@rs.jp.nec.com> 

---
 fs/ext4/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
 		break;
 	case EXT4_IOC_GROUP_ADD:
 		break;
+	case EXT4_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}

