Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZHCOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZHCOCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZHCOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:02:46 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38754 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZHCOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:02:46 -0400
Date: Mon, 3 Aug 2009 10:02:23 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/disk-io.c:2221!
Message-ID: <20090803140223.GB3765@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1249120208.14496.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249120208.14496.3.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A76EDF1.0156:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 11:50:08AM +0200, Thomas Meyer wrote:
> kernel BUG at fs/btrfs/disk-io.c:2221! 
> invalid opcode: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/block/sdc/sdc1/start

Could you please confirm that line 2221 in your disk-io.c looks like
this:

2219 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct
btrfs_root *root)
2220 {
2221         WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
2222         radix_tree_delete(&fs_info->fs_roots_radix,
2223                           (unsigned long)root->root_key.objectid);
2224         if (root->anon_super.s_dev) {
2225                 down_write(&root->anon_super.s_umount);
2226                 kill_anon_super(&root->anon_super);
2227         }

That's in the unmount path but not under write_ctree_supers, so I want
to make sure I'm looking at the right bug ;)

-chris

