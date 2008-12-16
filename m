Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYLPGpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYLPGpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYLPGpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:45:32 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48168 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYLPGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:45:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EhGWaGUM9EiG15eQt2QjJt2p3+srEsbRohQNQtzKpxBhOyFZlxmJZmWetZTpP90Hke
         oxu1YuG1McJUKB+6MpuIuO0mNdBG9LANn001jzOrB1lX15taZHK7BlcACEXTNFOxhEAb
         FG+eqLl7eoV0V1YHPAm/CYjZPygiXd7ygaook=
Message-ID: <aa79d98a0812152245v49a183f8q6cdc2163e6797b2e@mail.gmail.com>
Date: Tue, 16 Dec 2008 09:45:29 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs - fix name overwrite in __register_chrdev_region
Cc: "Alexander Viro" <aviro@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081215215706.7707315c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081213214911.GI16354@localhost>
	 <20081215215706.7707315c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 8:57 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> OK.
>
> strlcpy() prodces a more pleasing result:
>
> --- a/fs/char_dev.c~fs-fix-name-overwrite-in-__register_chrdev_region
> +++ a/fs/char_dev.c
> @@ -120,7 +120,7 @@ __register_chrdev_region(unsigned int ma
>        cd->major = major;
>        cd->baseminor = baseminor;
>        cd->minorct = minorct;
> -       strncpy(cd->name,name, 64);
> +       strlcpy(cd->name, name, sizeof(cd->name));
>
>        i = major_to_index(major);
>
> _
>

Thanks, Andrew!
