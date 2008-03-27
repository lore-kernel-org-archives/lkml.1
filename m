Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYC0VyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYC0VyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYC0VyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:54:06 -0400
Received: from testure.choralone.org ([194.9.77.134]:35978 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbYC0VyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:54:05 -0400
Date: Thu, 27 Mar 2008 17:53:40 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: cifs_mount() contains strange code
Message-ID: <20080327215340.GA27219@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Adrian Bunk <bunk@kernel.org>, sfrench@samba.org,
	linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
References: <20080327173458.GA32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327173458.GA32200@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 07:34:58PM +0200, Adrian Bunk wrote:
 > This looks somehow fishy (note the "rc" settings):
 > 
 > <--  snip  -->
 > 
 > ...
 > int
 > cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 >            char *mount_data, const char *devname)
 > {
 > ...
 >                                 /* BB check if this works for exactly length
 >                                  * three strings */
 >                                 if ((strchr(volume_info.UNC + 3, '\\') == NULL)
 >                                     && (strchr(volume_info.UNC + 3, '/') ==
 >                                         NULL)) {
 >                                         rc = connect_to_dfs_path(xid, pSesInfo,
 >                                                 "", cifs_sb->local_nls,
 >                                                 cifs_sb->mnt_cifs_flags &
 >                                                   CIFS_MOUNT_MAP_SPECIAL_CHR);
 >                                         rc = -ENODEV;
 >                                         goto out;
 > 
 > <--  snip  -->

I've noticed a bunch of things like that from time to time, and wondered
how useful it would be to have sparse warn on double assignments of variables
without a read inbetween.

	Dave

-- 
http://www.codemonkey.org.uk
