Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754569AbYLQPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLQPlT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYLQPlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:41:04 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:59583 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYLQPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:41:03 -0500
Message-ID: <49491D88.3020106@diamondcut.com.br>
Date: Wed, 17 Dec 2008 13:40:56 -0200
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: torvalds@linux-foundation.org, sfrench@gmail.com,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cifs: fix buffer overrun in parse_DFS_referrals
References: <1229513513-16445-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1229513513-16445-1-git-send-email-jlayton@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> ---
>  fs/cifs/cifssmb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 9395928..824df14 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3992,7 +3992,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
>  
>  		node->flags = le16_to_cpu(pSMBr->DFSFlags);
>  		if (is_unicode) {
> -			__le16 *tmp = kmalloc(strlen(searchName)*2, GFP_KERNEL);
> +			__le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
> +						GFP_KERNEL);
>  			cifsConvertToUCS((__le16 *) tmp, searchName,
>  					PATH_MAX, nls_codepage, remap);
>  			node->path_consumed = hostlen_fromUCS(tmp,

This patch can't be applied in -stable release:

yamane@mandachuva:~/kernel/linux-2.6.27.9$ patch -p1 < cifs.patch
patching file fs/cifs/cifssmb.c
patch unexpectedly ends in middle of line
Hunk #1 FAILED at 3992.
1 out of 1 hunk FAILED -- saving rejects to file fs/cifs/cifssmb.c.rej

Best regards,
Renato
