Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYC0RfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYC0RfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYC0RfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:35:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38026 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbYC0RfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:35:10 -0400
Date: Thu, 27 Mar 2008 19:34:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: sfrench@samba.org
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: cifs_mount() contains strange code
Message-ID: <20080327173458.GA32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks somehow fishy (note the "rc" settings):

<--  snip  -->

...
int
cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
           char *mount_data, const char *devname)
{
...
                                /* BB check if this works for exactly length
                                 * three strings */
                                if ((strchr(volume_info.UNC + 3, '\\') == NULL)
                                    && (strchr(volume_info.UNC + 3, '/') ==
                                        NULL)) {
                                        rc = connect_to_dfs_path(xid, pSesInfo,
                                                "", cifs_sb->local_nls,
                                                cifs_sb->mnt_cifs_flags &
                                                  CIFS_MOUNT_MAP_SPECIAL_CHR);
                                        rc = -ENODEV;
                                        goto out;

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

