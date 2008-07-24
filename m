Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYGXAUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYGXAUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYGXAUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:20:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:2395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYGXAUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gVwmRTv7qEsyfpeeIXyHTYbK7OyhQKNn5DL+j0aBI7i2c3l8Y6kvqxqEg1xqHyTIdr
         ju7gCQZdPcJQ076UhuPAsWoZVStiHvKNUZjKkaOQg15agk+RwVUpwAq9s8iQBb6m9PsI
         ALxuTo9891n3RRAK9RRTxpAs+Ij7qOUTs0nnM=
Message-ID: <524f69650807231719y33e96d02y7b04d1115620aa1d@mail.gmail.com>
Date: Wed, 23 Jul 2008 19:19:34 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] cifs: avoid mixing bool and le16
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1216857138.30386.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216857138.30386.33.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like a cast to bool or an "if ...else" would be clearer than using !!
By the way I don't see this warning - is it a newer compiler warning?

On Wed, Jul 23, 2008 at 6:52 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> fs/cifs/cifssmb.c:3917:13: warning: incorrect type in assignment (different base types)
> fs/cifs/cifssmb.c:3917:13:    expected bool [unsigned] [usertype] is_unicode
> fs/cifs/cifssmb.c:3917:13:    got restricted __le16
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 4511b70..56f1a71 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3914,7 +3914,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
>        bool is_unicode;
>        struct dfs_referral_level_3 *ref;
>
> -       is_unicode = pSMBr->hdr.Flags2 & SMBFLG2_UNICODE;
> +       is_unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
>        *num_of_nodes = le16_to_cpu(pSMBr->NumberOfReferrals);
>
>        if (*num_of_nodes < 1) {
> --
> 1.5.6.4.570.g052e
>
>
>
>



-- 
Thanks,

Steve
