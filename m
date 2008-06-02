Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYFBQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYFBQMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYFBQMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:12:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:8842 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFBQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nZ3mEjAP65IEJcDvmbQKzBoVnaY1LbQDLJ18DEV+Wcbpz77sat1MuYhmJqVH7iE0/rS3UKxflYuP8sg0Nh2y4QG2kS3zq7eNojkknY2I+jm/Mxg1SsP01xw5pI9IqexRVxZoacAHlOOnj+qkFAMhUDQF7nLTkMZIP00mjA2pRQg=
Message-ID: <84144f020806020911x4a74b32dj3192055a0320bd64@mail.gmail.com>
Date: Mon, 2 Jun 2008 19:11:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Cc: linux-kernel@vger.kernel.org, "Pavel Emelyanov" <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>, "Jan Kara" <jack@suse.cz>
In-Reply-To: <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
	 <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
X-Google-Sender-Auth: e3db68ddc23f984f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 10:00 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c447e07..10ee4a2 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2589,6 +2589,9 @@ static struct dentry
> *proc_pid_instantiate(struct inode *dir,
>  #ifdef CONFIG_SECURITY
>        inode->i_nlink += 1;
>  #endif
> +#ifdef CONFIG_NET

#if defined(CONFIG_SECURITY) || defined(CONFIG_NET) ?

> +       inode->i_nlink += 1;
> +#endif
>
>        dentry->d_op = &pid_dentry_operations;
>
> --
> 1.5.4.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
