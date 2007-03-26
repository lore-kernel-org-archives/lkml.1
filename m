Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXCZRwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXCZRwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXCZRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:52:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:47781 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbXCZRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pHN7AhfjHB7H5PfUy9T/68tSIalIEwfwDRMVJBgL3nvSLAwgEpx4u52CrvtGI4/Cb//8g/3ug1yV49KhvOCsLNPp75mAZj+zZ3zSj1jb1OJOaIyjauMDTTekXdR4/BVq7OUu1OR1Wsi54PRF5fy/zEmtZbF4mqfS4mN+hopHgNA=
Date: Mon, 26 Mar 2007 22:52:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joerg Roedel <joro-lkml@zlug.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] riscom8: fix use of deprecated functions
Message-ID: <20070326185209.GA5293@martell.zuzino.mipt.ru>
References: <20070325203601.GA13788@zlug.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325203601.GA13788@zlug.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 10:36:02PM +0200, Joerg Roedel wrote:
> This patch replaces the deprecated functions in drivers/char/riscom8.c
> and fixes the compile warnings they produced.

That's not the point of exercise. Make it SMP-safe, instead.

> --- a/drivers/char/riscom8.c
> +++ b/drivers/char/riscom8.c
> @@ -226,13 +226,13 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
>  {
>  	unsigned long flags;
>
> -	save_flags(flags); cli();
> +	local_irq_save(flags);

