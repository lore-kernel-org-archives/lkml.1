Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYBGShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYBGShq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYBGShi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:37:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbYBGShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:37:37 -0500
Date: Thu, 7 Feb 2008 10:36:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
       stable@kernel.org
Subject: Re: [PATCH] quota: Turn quotas off when remounting read-only
Message-Id: <20080207103655.14ce8512.akpm@linux-foundation.org>
In-Reply-To: <20080207143721.GH6140@duck.suse.cz>
References: <20080207143721.GH6140@duck.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 15:37:21 +0100 Jan Kara <jack@suse.cz> wrote:

> Turn off quotas before filesystem is remounted read only. Otherwise quota will
> try to write to read-only filesystem which does no good... We could also just
> refuse to remount ro when quota is enabled but turning quota off is consistent
> with what we do on umount.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> Andrew, this should fix the hang reported... Please apply. Thanks.
> 
> diff --git a/fs/super.c b/fs/super.c
> index ceaf2e3..945c322 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -603,6 +603,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  			mark_files_ro(sb);
>  		else if (!fs_may_remount_ro(sb))
>  			return -EBUSY;
> +		DQUOT_OFF(sb);
>  	}
>  
>  	if (sb->s_op->remount_fs) {

Cool.  And this is applicable to 2.6.23, 2.6.22 and even earlier, isn't it?
