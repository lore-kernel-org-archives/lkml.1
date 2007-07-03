Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbXGCO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbXGCO3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXGCO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:29:09 -0400
Received: from pat.uio.no ([129.240.10.15]:60637 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbXGCO3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:29:07 -0400
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
In-Reply-To: <1183388313.3864.35.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
	 <1183388313.3864.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 10:24:42 -0400
Message-Id: <1183472682.6494.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.106)
X-UiO-Scanned: 673A59E5835321C9518CA47E8E88CEFB73EDF900
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 488 total 2696568 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 10:58 -0400, Mingming Cao wrote:
> Trond or Bruce, can you please review these patch series and ack if you
> agrees? Thanks.
> 
> As to performance concerns that raise before the inode version counter
> (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> no extra IO work to store this counter to disk.

Hi Mingming,

It looks OK to me, but you might want to strip out the now redundant
i_version updates in add_dirent_to_buf(), ext4_rmdir(), ext4_rename().

I also have some questions about how this will affect the readdir code:
unless I missed something, the filp->f_version is still unsigned long,
so the comparisons and assignments in ext4_readdir()/ext4_dx_readdir()
no longer make sense.

Cheers
  Trond

