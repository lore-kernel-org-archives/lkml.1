Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYL0MX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYL0MX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYL0MXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:23:48 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:33332 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753609AbYL0MXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:23:47 -0500
Date: Sat, 27 Dec 2008 15:22:15 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ufs: ensure fast symlinks are NUL-terminated
Message-ID: <20081227122215.GA25619@rain>
Mail-Followup-To: Duane Griffin <duaneg@dghda.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com> <1229442720-31056-2-git-send-email-duaneg@dghda.com> <1229442720-31056-3-git-send-email-duaneg@dghda.com> <1229442720-31056-4-git-send-email-duaneg@dghda.com> <1229442720-31056-5-git-send-email-duaneg@dghda.com> <1229442720-31056-6-git-send-email-duaneg@dghda.com> <1229442720-31056-7-git-send-email-duaneg@dghda.com> <20081216194053.GA17671@rain> <20081216231850.GA12692@dastardly.home.dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216231850.GA12692@dastardly.home.dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:18:50PM +0000, Duane Griffin wrote:
> On Tue, Dec 16, 2008 at 10:40:55PM +0300, Evgeniy Dushistov wrote:
> > There is different types of ufs, one used 64 bit for "pointers to
> > blocks", another 32 bit,
> > so sizeof(UFS_I(inode)->i_u1.i_symlink))
> > is not right choice every time,
> > in ufs2 it should be
> > sizeof(UFS_I(inode)->i_u1.u2_i_data) which 2 times bigger,
> > 
> > also there is hint for *BSD ufs
> > 
> > fs/ufs/ufs_fs.h:
> > __fs32	fs_maxsymlinklen;/* max length of an internal symlink */
> > 
> > which may be used if ufs type ufs1 or ufs2
> 
> Hmm, I see. However it looks like ufs1_read_inode and ufs2_read_inode
> both copy the same, ((UFS_NDADDR + UFS_NINDIR) * 4), amount of inline
> symlink data. They also both copy it to ufs_inode_info->i_u1.i_symlink
> (not that that matters, I suppose). Perhaps I'm being obtuse, but it
> looks like inline ufs2 symlinks between 60 and 120 characters long are
> being truncated to 60 characters, no?
> 
> There also doesn't seem to be any validation of (f)s_maxsymlinklen being
> done. Unless I'm mistaken ufs_symlink could end up overwriting random
> memory if it contains a large bogus value.
> 
> Does that all sound correct? If so would you like me to whip up a couple
> of patches to fix it? I'll respin the NUL-termination patch on top of
> those, if so.
> 

Yes, it looks like there is typo in ufs2 variant of copying symlink names.
Typical value of superblock's maxsymlinklen field for ufs2 is 120.
Patches to fix this are welcome.

-- 
/Evgeniy

