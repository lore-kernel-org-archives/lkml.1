Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYGXBkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYGXBkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYGXBkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:40:12 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:62265 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYGXBkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lGEn+OwxDG1CqdW6+eHup1nD/fnrIDl+eB4wHPfxS/WtjEplD2kpXmh3sfHjXty+vC
         UHBIJDUbfjqgmTWmxpjqq/dS72O9XqauUoWts5CfP1d/q7zlxorVHNp62ypLqILsY+J7
         Y7Q+U802vN+sNHLieDD0Es1Fj1gLmijnhI4r4=
Message-ID: <524f69650807231839g399f57a8ied548d81eefdbebd@mail.gmail.com>
Date: Wed, 23 Jul 2008 20:39:37 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
Subject: Re: cifs: suggestions for a few more sparse warnings
Cc: "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1216860920.30386.55.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216860920.30386.55.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 7:55 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> Here's a patch for some of the other warnings, but the cifsacl.c bit
> needs a comment I think.
>
> Harvey
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 34902cf..70f0ef5 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -169,8 +169,7 @@ static void copy_sec_desc(const struct cifs_ntsd *pntsd,
>        for (i = 0; i < 6; i++)
>                ngroup_sid_ptr->authority[i] = group_sid_ptr->authority[i];
>        for (i = 0; i < 5; i++)
> -               ngroup_sid_ptr->sub_auth[i] =
> -                               cpu_to_le32(group_sid_ptr->sub_auth[i]);
> +               cpu_to_le32s(&group_sid_ptr->sub_auth[i]);
>
>        return;
>  }

No - the cifsacl one looks like just a bug - there should not be an
endian conversion here.

Shirish,
Would you verify?

-- 
Thanks,

Steve
