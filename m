Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZGVPQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZGVPQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZGVPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:16:41 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:58144 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGVPQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fDpwqCqKLO7LsiDlcpE0vMiAIbWfuTLdeqQrqu9jXzc2R7d1ds166U/fNciH2H8T7u
         830sfu6io6UthKtDnUJ28VD/Ge7fMo9tYmanMtz7t8ffUgWdSjjYX5VS+ZWKHMTZqVWJ
         0B/eqyMoV/xuUmU2yFxyLrwIxgV1Kk4C6RsbQ=
MIME-Version: 1.0
In-Reply-To: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
References: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
Date: Wed, 22 Jul 2009 10:16:38 -0500
Message-ID: <524f69650907220816j6400c1fdr4efd8754437f7a13@mail.gmail.com>
Subject: Re: [PATCH] libfs: make get_sb_pseudo set s_maxbytes to value that 
	can be cast to signed
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack

On Wed, Jul 22, 2009 at 6:28 AM, Jeff Layton<jlayton@redhat.com> wrote:
> This patch is a counterpart to the CIFS patch posted yesterday. I
> believe either patch will fix the problem seen in do_sendfile since the
> smaller s_maxbytes value for the two superblocks is used there.
>
> get_sb_pseudo sets s_maxbytes to ~0ULL, which becomes negative when cast
> to a signed value. Fix it to use MAX_LFS_FILESIZE which casts properly
> to a positive signed value.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/libfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/libfs.c b/fs/libfs.c
> index ddfa899..dcec3d3 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -217,7 +217,7 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
>                return PTR_ERR(s);
>
>        s->s_flags = MS_NOUSER;
> -       s->s_maxbytes = ~0ULL;
> +       s->s_maxbytes = MAX_LFS_FILESIZE;
>        s->s_blocksize = PAGE_SIZE;
>        s->s_blocksize_bits = PAGE_SHIFT;
>        s->s_magic = magic;
> --
> 1.6.0.6
>
>



-- 
Thanks,

Steve
