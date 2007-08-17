Return-Path: <linux-kernel-owner+w=401wt.eu-S1764723AbXHQWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764723AbXHQWR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXHQWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:17:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:46303 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXHQWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q5Ca/uKSaXGuiA32erSqfGadYYfeOzGiaPqDcPuUsWBmmrscLePp8Vbl8R9Ferwx+7A2yx0laIHeMTdz2alB7Tp1T2vdqJGzFRfDnerZHEbh5YTVjE5RVajenaVPaHSfq4mjVCMPJcLiMXbI/XYdfN1iSVTvwuFn95AR0qUELC0=
Message-ID: <9a8748490708171517m4c6f1330jf7990b68cebe4768@mail.gmail.com>
Date: Sat, 18 Aug 2007 00:17:33 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + cifs-check-for-granted-memory.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, gorcunov@gmail.com, sfrench@us.ibm.com
In-Reply-To: <200708172150.l7HLoXqT031088@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708172150.l7HLoXqT031088@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      CIFS: check for granted memory
> has been added to the -mm tree.  Its filename is
>      cifs-check-for-granted-memory.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> ------------------------------------------------------
> Subject: CIFS: check for granted memory
> From: Cyrill Gorcunov <gorcunov@gmail.com>
>
> Add a check for granted memory to prevent possible NULL pointer usage.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Steven French <sfrench@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/cifs/sess.c |    4 ++++
>  1 files changed, 4 insertions(+)
>
> diff -puN fs/cifs/sess.c~cifs-check-for-granted-memory fs/cifs/sess.c
> --- a/fs/cifs/sess.c~cifs-check-for-granted-memory
> +++ a/fs/cifs/sess.c
> @@ -372,6 +372,10 @@ CIFS_SessSetup(unsigned int xid, struct
>
>         /* 2000 big enough to fit max user, domain, NOS name etc. */
>         str_area = kmalloc(2000, GFP_KERNEL);
> +       if (str_area == NULL) {
> +               cifs_small_buf_release(smb_buf);
> +               return -ENOMEM;
> +       }

The patch, as such, is fine - not arguing against it, but as a matter
of style; don't we usually prefer the "if (!foo)" form over "if (foo
== NULL)" ??

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
