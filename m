Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZHaSsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZHaSsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZHaSsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:48:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50174 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZHaSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gp3wvQfoMcbndTj75xdA8dAxGe/iLlf+r/VVSysexkcUl7DR+1Y3mZUGiG8AGG9nqN
         Ontui8AOhNRfhG5HdiuxjqEo+DN0GGnY5+tBQX323FYc1fFUdXUW5R6A0TQ6jEPnWyjy
         aEtQpQ6dWJaZh75HSgtornrNFY3wqdlb83CFY=
MIME-Version: 1.0
In-Reply-To: <20090831182754.GA3620@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	 <20090831123010.GA2368@infradead.org>
	 <64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
	 <20090831182754.GA3620@infradead.org>
Date: Mon, 31 Aug 2009 20:42:55 +0200
Message-ID: <64bb37e0908311142y4f9b6a8ex4918ac4dea09a4d2@mail.gmail.com>
Subject: Re: xfs compat_ioctl?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 8:27 PM, Christoph Hellwig<hch@infradead.org> wrote:
> I think you are right, the constant used is incorrect.  Does the small
> patch below fix it for you?

Thanks, I will try it tomorrow.

Torsten

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c       2009-08-31 15:25:06.093044591 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c    2009-08-31 15:25:10.856544216 -0300
> @@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
>        case XFS_IOC_GETVERSION_32:
>                cmd = _NATIVE_IOC(cmd, long);
>                return xfs_file_ioctl(filp, cmd, p);
> -       case XFS_IOC_SWAPEXT: {
> +       case XFS_IOC_SWAPEXT_32: {
>                struct xfs_swapext        sxp;
>                struct compat_xfs_swapext __user *sxu = arg;
>
>
