Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYC3D1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYC3D1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 23:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYC3D1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 23:27:31 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:36625 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYC3D1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 23:27:30 -0400
Date: Sat, 29 Mar 2008 23:27:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] omfs: add bitmap routines
Message-ID: <20080330032710.GC18825@hash.localnet>
References: <1206578760-9050-5-git-send-email-me@bobcopeland.com> <200803280451.11216.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803280451.11216.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 04:51:10AM +0100, Arnd Bergmann wrote:
> On Thursday 27 March 2008, Bob Copeland wrote:
> 
> > +unsigned long omfs_count_free(struct super_block *sb)
> 
> I think it would be helpful to express this using hweight64.

Here's a version with hweight64:

+unsigned long omfs_count_free(struct super_block *sb)
+{
+	unsigned int i, j;
+	u64 *map;
+	unsigned long sum = 0;
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+
+	for (i = 0; i < sbi->s_imap_size; i++) {
+		map = (u64 *) sbi->s_imap[i];
+		for (j = 0; j < sb->s_blocksize / 8; j++)
+			sum += hweight64(~map[j]);
+	}
+	return sum;
+}

-- 
Bob Copeland %% www.bobcopeland.com 

