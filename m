Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYFILxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYFILxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYFILw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:52:59 -0400
Received: from mail.transmode.se ([83.241.175.147]:35653 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754815AbYFILw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:52:59 -0400
Subject: Re: [PATCH] seq_file: make seq_lseek accept SEEK_END
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Alexey Dobriyan <adobriyan@parallels.com>
Cc: akpm@osdl.org, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       "busybox@busybox.net" <busybox@busybox.net>
In-Reply-To: <200806091501.13170.adobriyan@parallels.com>
References: <200806091501.13170.adobriyan@parallels.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Mon, 09 Jun 2008 13:52:55 +0200
Message-Id: <1213012375.16530.9.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

busybox has been fixed, at least in trunk, not to do 
xlseek(fd, 0, SEEK_END) anymore to address this problem.
Perhaps there are other apps out there that needs this too, but I don't
know of any. Older busyboxes needs this change though.
I have moved on and don't have a setup handy where I can test this.
Perhaps someone at the bb list has, CC:ing bb list.

 Jocke

On Mon, 2008-06-09 at 15:01 +0400, Alexey Dobriyan wrote:
> Apologies for delay, such simple thing should have been sent long ago.
> Joakim, please, confirm.
> -------------------------------------------
> [PATCH] seq_file: make seq_lseek accept SEEK_END
> 
> and pretend seq_files have zero length. This should be enough
> to fix busybox start-stop-daemon:
> http://marc.info/?t=120836691600002&r=1&w=2
> 
> It does xlseek(fd, 0, SEEK_END) to estimate amount of memory to malloc
> but satisfied with 0. Sudden -EINVAL from lseek(2) breaks it.
> 
> X-Introduced-By: f16278c679aa72e28288435b313ba2d4494d6be5
> Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
> ---
> 
>  fs/seq_file.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -254,6 +254,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int origin)
>  	switch (origin) {
>  		case 1:
>  			offset += file->f_pos;
> +		case 2:
> +			/* pretend it's zero length */
>  		case 0:
>  			if (offset < 0)
>  				break;
> 
> 
