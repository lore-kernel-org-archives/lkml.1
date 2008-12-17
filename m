Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758880AbYLQDfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYLQDfA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYLQDes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:34:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:33962 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLQDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MD5QZt1k9Jvvt6YUScGRufAnuHON4QCPsoajWNH/cDLRdXLGreMiEOqAqkkQM4vpoT
         PKNybPLt9paQTtxW4Z2QDwIuyF/JTmmnZ6GLDPjFa9CPEPbzdiup3pdXxPYm84XZGOUE
         rNYLu6VS2kA62eP+cFX9A15B5Jp3rKOoCdiII=
Message-ID: <524f69650812161934h16df87d9w83f5711a8ea8932f@mail.gmail.com>
Date: Tue, 16 Dec 2008 21:34:45 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: fix buffer overrun in parse_DFS_referrals
Cc: niallain@gmail.com, smfrench@austin.rr.com,
        linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <1229439864-3903-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229439864-3903-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff.
Would you add my ack, and the cc: for stable and send to Linus?  I
think this should go in.

On Tue, Dec 16, 2008 at 9:04 AM, Jeff Layton <jlayton@redhat.com> wrote:
> While testing a kernel with memory poisoning enabled, I saw some warnings
> about the redzone getting clobbered when chasing DFS referrals. The
> buffer allocation for the unicode converted version of the searchName is
> too small and needs to take null termination into account.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
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
>                node->flags = le16_to_cpu(pSMBr->DFSFlags);
>                if (is_unicode) {
> -                       __le16 *tmp = kmalloc(strlen(searchName)*2, GFP_KERNEL);
> +                       __le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
> +                                               GFP_KERNEL);
>                        cifsConvertToUCS((__le16 *) tmp, searchName,
>                                        PATH_MAX, nls_codepage, remap);
>                        node->path_consumed = hostlen_fromUCS(tmp,
> --
> 1.5.5.1
>
>



-- 
Thanks,

Steve
