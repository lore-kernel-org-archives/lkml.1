Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZCYCbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZCYCbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCYCb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:31:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20583 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZCYCb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BIK5lhk8nW5qIh7AlbuSqsMhYtxuuZ3VXvUnK7Gx+XgaF+IuyqI8CPBnO+Ckysrpbx
         hwfxB+CNXI3BDsey869iIvxzhYRNSjHgiPgRelAYQLEfcT8IHvtlkc1Q3iTeWm6AGRFV
         3LzgGlFXJoIlJE4K7ZR7tyRXL9FEFOqYX0sWM=
MIME-Version: 1.0
In-Reply-To: <1237929168-15341-5-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-5-git-send-email-stoyboyker@gmail.com>
Date: Tue, 24 Mar 2009 22:31:25 -0400
Message-ID: <8bd0f97a0903241931r6ecba9dwc64bb803319efea4@mail.gmail.com>
Subject: Re: [PATCH 04/13] [blackfin] changed ioctls to unlocked
From: Mike Frysinger <vapier.adi@gmail.com>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, cooloney@kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 17:12,  <stoyboyker@gmail.com> wrote:
> --- a/arch/blackfin/mach-bf561/coreb.c
> +++ b/arch/blackfin/mach-bf561/coreb.c
> @@ -220,9 +220,10 @@ static int coreb_release(struct inode *inode, struct file *file)
>        return 0;
>  }
>
> -static int coreb_ioctl(struct inode *inode, struct file *file,
> -                      unsigned int cmd, unsigned long arg)
> +static long coreb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +       lock_kernel();
> +
>        int retval = 0;
>        int coreb_index = 0;
>
> @@ -289,6 +290,7 @@ static int coreb_ioctl(struct inode *inode, struct file *file,
>  #endif
>        }
>
> +       unlock_kernel();
>        return retval;
>  }

there is no need to lock the kernel in here.  people have asked in the
past and we've told them that it's pointless.  simply change it to use
unlocked_ioctl.
-mike
