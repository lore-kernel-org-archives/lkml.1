Return-Path: <linux-kernel-owner+w=401wt.eu-S965582AbXHMDIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582AbXHMDIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbXHMDI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:08:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:22607 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759716AbXHMDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ksO5AUbeTVJ2lRXMBb+jrwhJMYxp5sZz0LG+xaSyLfb/G0PN96yT5okbU9FYydzUniSGbd/JnRAUqTZbGw69aB2qLde0iqifxNP1l42EL/moUQ0dw/X3ZCUQmm8OfVLTxBodycdIakT55idDXceRQCbQNBdm/1gLKuyzNwuRPvI=
Message-ID: <91b13c310708122008w27b86359n5b135df3e229e616@mail.gmail.com>
Date: Mon, 13 Aug 2007 11:08:26 +0800
From: "rae l" <crquan@gmail.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Subject: Re: [PATCH] gfs2: better code for translating characters
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <11869741183677-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11869741183677-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Denis Cheng <crquan@gmail.com> wrote:
> the original code could work, but I think this code could work better.
>
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/gfs2/ops_fstype.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index cf5aa50..b9a7759 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -145,7 +145,8 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
>         snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
>         snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
>
> -       while ((table = strchr(sdp->sd_table_name, '/')))
> +       table = sdp->sd_table_name;
> +       while ((table = strchr(table, '/')))
>                 *table = '_';
Sorry, I don't know what the while loop really means, what's the
common case that slash character exists? if the '/' appears multiple,
the latter code would be better; however, if slash appears rarely, the
original would still be better.

>
>  out:
> --
> 1.5.2.2
>
>


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
