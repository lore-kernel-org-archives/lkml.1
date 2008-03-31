Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbYCaHmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbYCaHmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYCaHmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:42:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:23565 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYCaHmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YKbhwhe+xkiVi0FrTe5+/uqAQOU54GYkdoFStR106JswtWtzN1Qc/XFXxndSWQZ0AXCDGUM8CRYRDqUzbhqO+vsUounhkyldejvYaJLYpEpkp4oxVBuupI2qIaD835Ha8Zb0liczSJegzaNS8qm9w+GykRtk9rmUVrV1Ny1y4E4=
Message-ID: <71bff3710803310042l50d347dcx43388f0941cdc39@mail.gmail.com>
Date: Mon, 31 Mar 2008 11:42:05 +0400
From: "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] cifs: make connect_to_dfs_path() static
Cc: "Steve French" <sfrench@us.ibm.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080330223956.GA28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080330223956.GA28445@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 05fcd994344056cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: connect_to_dfs_path() probably will be removed when I complete dfs root
mounting functionality.

On Mon, Mar 31, 2008 at 2:39 AM, Adrian Bunk <bunk@kernel.org> wrote:
> connect_to_dfs_path() can now become static.
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>  ---
>
>   fs/cifs/cifsproto.h |    3 ---
>   fs/cifs/connect.c   |    2 +-
>   2 files changed, 1 insertion(+), 4 deletions(-)
>
>  87f02b93ed23ec4229a006d5866745473cb4c15e diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>  index 7e5e0e7..c9dd2ca 100644
>  --- a/fs/cifs/cifsproto.h
>  +++ b/fs/cifs/cifsproto.h
>  @@ -154,9 +154,6 @@ extern int CIFSGetDFSRefer(const int xid, struct cifsSesInfo *ses,
>                         unsigned int *number_of_UNC_in_array,
>                         const struct nls_table *nls_codepage, int remap);
>
>  -extern int connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
>  -                       const char *old_path,
>  -                       const struct nls_table *nls_codepage, int remap);
>   extern int get_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
>                         const char *old_path,
>                         const struct nls_table *nls_codepage,
>  diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>  index 8dbfa97..61b2b0a 100644
>  --- a/fs/cifs/connect.c
>  +++ b/fs/cifs/connect.c
>  @@ -1405,7 +1405,7 @@ find_unc(__be32 new_target_ip_addr, char *uncName, char *userName)
>         return NULL;
>   }
>
>  -int
>  +static int
>   connect_to_dfs_path(int xid, struct cifsSesInfo *pSesInfo,
>                     const char *old_path, const struct nls_table *nls_codepage,
>                     int remap)
>
>
