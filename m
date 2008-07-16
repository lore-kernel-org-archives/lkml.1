Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYGPHFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYGPHFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGPHE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:04:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:12304 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYGPHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l3eco1A8v/oudSH2ogTkd2kr+1O+457Cu1ghr5QL0eTdb+ZEdgA2qdG+UV2zHa61YK
         0XSXCZWOQByU6rdsh8vBeRqqPLA9YxCch99Sc2ivNDCXBj5gHuuREQj+fAPvNyltbSce
         S4H0WyP8nW5yGYZnoSDsby3gPaYd6m262wjJU=
Message-ID: <84144f020807160004g77443c1t25723e693d6aaa0a@mail.gmail.com>
Date: Wed, 16 Jul 2008 10:04:56 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Adam Greenblatt" <adam.greenblatt@gmail.com>
Subject: Re: [PATCH 2.6.26] isofs: fix minor filesystem corruption
Cc: akpm@linux-foundation.org, jack@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <487D7BF9.60509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487D7BF9.60509@gmail.com>
X-Google-Sender-Auth: 7c0a95f1ca4d5f0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On Wed, Jul 16, 2008 at 7:41 AM, Adam Greenblatt
<adam.greenblatt@gmail.com> wrote:
> Some iso9660 images contain files with rockridge data that is either
> incorrect or
> incompletely parsed.  Prior to commit
> f2966632a134e865db3c819346a1dc7d96e05309,
> (included with kernel 2.6.13) the kernel ignored the rockridge data for
> these files,
> while still allowing the files to be accessed under their non-rockridge
> names.  That commit
> inadvertently changed things so that files with invalid rockridge data could
> not be accessed
> at all.  (I ran across the problem when comparing some old CDs with hard
> disk copies I had
> made long ago under kernel 2.4: a few of the files on the hard disk copies
> were no longer
> visible on the CDs.)
>
> This change reverts to the pre-2.6.13 behavior.
>
> Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
> ---
> --- linux-2.6.26/fs/isofs/rock.c.orig   2008-07-15 18:19:36.000000000 -1000
> +++ linux-2.6.26/fs/isofs/rock.c        2008-07-15 18:16:56.000000000 -1000
> @@ -217,7 +217,7 @@ repeat:
>               rs.chr += rr->len;
>               rs.len -= rr->len;
>               if (rs.len < 0)
> -                       goto eio;       /* corrupted isofs */
> +                       goto out;       /* corrupted isofs */
>
>               switch (sig) {
>               case SIG('R', 'R'):

I suppose you want to fix parse_rock_ridge_inode_internal() also for
consistency and add a comment there why we don't fail for that case.
