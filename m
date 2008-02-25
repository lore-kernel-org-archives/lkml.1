Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYBYV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYBYV6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBYV5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:57:52 -0500
Received: from styx.suse.cz ([82.119.242.94]:38490 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbYBYV5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:57:51 -0500
Date: Mon, 25 Feb 2008 22:57:49 +0100
From: Jan Kara <jack@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 06/38] quota: turn quotas off when remounting read-only
Message-ID: <20080225215749.GC25449@duck.suse.cz>
References: <20080223001946.979768610@mini.kroah.org> <20080223002951.GG7268@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223002951.GG7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-02-08 16:29:51, Greg KH wrote:
> 2.6.24-stable review patch.  If anyone has any objections, please let us
> know.
  Hmm, this patch is certainly safe from a kernel POV but changes a
behavior WRT userspace. Previously, user could do:
  quotaon /
  mount -o remount,ro /
  <be lucky>
  mount -o remount,rw /
  <have quotas still turned on>

  But with the patch, the quotas will be turned off. So I'm not sure
whether it's acceptable as a -stable thing...

								Honza
> 
> ------------------
>  
> 
> From: Jan Kara <jack@suse.cz>
> 
> patch 66191dc622f5ff0a541524c4e96fdacfacfda206 in mainline.
> 
> Turn off quotas before filesystem is remounted read only.  Otherwise quota
> will try to write to read-only filesystem which does no good...  We could
> also just refuse to remount ro when quota is enabled but turning quota off
> is consistent with what we do on umount.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/super.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -603,6 +603,7 @@ int do_remount_sb(struct super_block *sb
>  			mark_files_ro(sb);
>  		else if (!fs_may_remount_ro(sb))
>  			return -EBUSY;
> +		DQUOT_OFF(sb);
>  	}
>  
>  	if (sb->s_op->remount_fs) {
> 
> -- 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
