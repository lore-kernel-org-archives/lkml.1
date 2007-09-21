Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXIUB45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXIUB45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbXIUB4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:56:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:22467 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXIUB4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ETbefYiP37ZSzwr8dvCc6dnyVXiqldxv/TICcmUdDEOpXbTIfCCsDcLF/Bhxz9VnBkqzxxbY1BYnBuwqE6I0y5QyhHxBtWZwEavcBqkhXPyIDLFOnM666nFueSgs22e+mCQ1yXDfWOjdCotdqcFSiZYs6E3Nh4OnNxENCr/c3ik=
Message-ID: <3402120c0709201856j58c3775bq8dc7886785a11344@mail.gmail.com>
Date: Fri, 21 Sep 2007 03:56:47 +0200
From: "Arvin Moezzi" <moezzia@gmail.com>
To: "James Pearson" <james-p@moving-picture.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
Cc: aarapov@redhat.com, akpm@linux-foundation.org, hpa@zytor.com
In-Reply-To: <E1IXziD-0003YJ-0w@moving-picture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IXziD-0003YJ-0w@moving-picture.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/19, James Pearson <james-p@moving-picture.com>:
> +       while (count > 0) {
> +               int this_len, retval;
> +
> +               this_len = mm->env_end - (mm->env_start + src);
> +
> +               if (this_len <= 0)
> +                       break;
> +
> +               if (this_len > max_len)
> +                       this_len = max_len;
> +
> +               retval = access_process_vm(task, (mm->env_start + src),
> +                       page, this_len, 0);
> +
> +               if (retval <= 0) {
> +                       ret = retval;
> +                       break;
> +               }
> +
> +               if (copy_to_user(buf, page, retval)) {
                                                                ^^^^
shouldn't you only copy min(count,retval) bytes? otherwise you could
write beyond the users buffer "buf", right?

Arvin
