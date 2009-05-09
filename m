Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZEIPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZEIPVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZEIPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:21:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41230 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZEIPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:21:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 May 2009 17:21:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.30-rc: reiserfs_delete_xattrs log spam (bug 13122)
To: Jeff Mahoney <jeffm@suse.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A058EBD.8030302@suse.com>
Message-ID: <tkrat.efedc43c9c935741@s5r6.in-berlin.de>
References: <4A057951.8040501@s5r6.in-berlin.de>
 <tkrat.fe49a8c298128f65@s5r6.in-berlin.de>
 <20090509130152.GD8633@ZenIV.linux.org.uk> <4A058EBD.8030302@suse.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 May, Jeff Mahoney wrote:
> Al Viro wrote:
>>> On  9 May, Stefan Richter wrote:
>>>> May  9 14:27:22 stein REISERFS warning (device sda1): jdm-20004 
>>>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>>>> May  9 14:27:22 stein
...
>> Could you try to bisect it?

I bisected it with a series of git-format-patch output on top of
2.6.29.3.  The last good one is "reiserfs: simplify xattr internal file
lookups/opens", the first bad one is "reiserfs: eliminate per-super xattr lock".
(Doh, what a surprise; grep'ing for the message in the diffs would have
pointed to this one too... Well, the bisection homed in quickly though.)
Of course that's only the patch which caused the symptoms to appear, not
necessarily the one which introduced the bug.

My config contains:
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set

(As mentioned, the filesystem was created and initially populated with a
kernel which was differently configured; I don't have an immediate idea
where to obtain the config.)

The tested series:

0001-reiserfs-add-support-for-mount-count-incrementing.patch
0002-reiserfs-audit-transaction-ids-to-always-be-unsigne.patch
0003-reiserfs-use-buffer_info-for-leaf_paste_entries.patch
0004-reiserfs-use-more-consistent-printk-formatting.patch
0005-reiserfs-make-some-warnings-informational.patch
0006-reiserfs-rework-reiserfs_warning.patch
0007-reiserfs-prepare_error_buf-wrongly-consumes-va_arg.patch
0008-reiserfs-eliminate-reiserfs_warning-from-uniqueness.patch
0009-reiserfs-add-locking-around-error-buffer.patch
0010-reiserfs-rework-reiserfs_panic.patch
0011-reiserfs-rearrange-journal-abort.patch
0012-reiserfs-introduce-reiserfs_error.patch
0013-reiserfs-use-reiserfs_error.patch
0014-reiserfs-small-variable-cleanup.patch
0015-reiserfs-xattr-reiserfs_get_page-takes-offset-inste.patch
0016-reiserfs-remove-link-detection-code.patch
0017-reiserfs-remove-IS_PRIVATE-helpers.patch
0018-reiserfs-Clean-up-xattrs-when-REISERFS_FS_XATTR-is.patch
0019-reiserfs-simplify-xattr-internal-file-lookups-opens.patch
0020-reiserfs-eliminate-per-super-xattr-lock.patch
0021-reiserfs-make-per-inode-xattr-locking-more-fine-gra.patch
# 0021 doesn't build, I skipped it.
0022-reiserfs-remove-i_has_xattr_dir.patch
0023-reiserfs-use-generic-xattr-handlers.patch
0024-reiserfs-journaled-xattrs.patch
# 0024 and later build only with A. Bergalov's fix folded in.
0025-reiserfs-use-generic-readdir-for-operations-across.patch
0026-reiserfs-add-atomic-addition-of-selinux-attributes.patch
0027-reiserfs-factor-out-buffer_info-initialization.patch
0028-reiserfs-cleanup-path-functions.patch
0029-reiserfs-strip-trailing-whitespace.patch
0030-reiserfs-rename-p_s_sb-to-sb.patch
0031-reiserfs-rename-p_s_bh-to-bh.patch
0032-reiserfs-rename-p_s_inode-to-inode.patch
0033-reiserfs-rename-p_s_tb-to-tb.patch
0034-reiserfs-rename-p_._-variables.patch
0035-reiserfs-rename-cn-_-variables.patch

> I'm looking into this right now. I have an idea, but I haven't been able
> to reproduce it yet to test.

Thanks, I can test something for you.
-- 
Stefan Richter
-=====-==--= -=-= -=--=
http://arcgraph.de/sr/
