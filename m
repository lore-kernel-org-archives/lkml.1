Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbXGRUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbXGRUSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXGRUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:18:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXGRUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Cm4/k86bnQjlUb+ZwmJb4fqAHPIJofpPc/Q33eTpyYDgRdnw8MJdiJ5qiDsemNww8JEEB3NKcu1IKbBS3jg6tuKS7aBfWfgP7lYi3nFYkp2S3TqQOZdtcVe/1brVqBN/5AJsoZBVGIK4rkP2nZzBLVOXSGjSbQqPIw+4BU2G0ZE=
Message-ID: <469E7599.4060608@gmail.com>
Date: Wed, 18 Jul 2007 22:18:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day napsal(a):
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   given that the entire contents of include/linux/tty.h is contained
> within an "#ifdef __KERNEL__", it seems pointless to export it to
> userspace, unless there's some kind of need for that header file to
> exist in userspace, even if it's empty.
> 
>   a quick grep shows that nothing under /usr/include references any
> file of the name "tty.h" in any way.  thoughts?

If we decide to remove the file, I would rather go through deprecation of the
file with filing an entry in feature-remove-schedule. There still seems to be
some users of the file.

With deprecation done with sth. like
#ifndef __KERNEL__
#warning Don't include this file from userspace, it's emtpy.
#endif

>  diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 4ff0f57..63de91a 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -328,7 +327,6 @@ unifdef-y += sysctl.h
>  unifdef-y += tcp.h
>  unifdef-y += time.h
>  unifdef-y += timex.h
> -unifdef-y += tty.h
>  unifdef-y += types.h
>  unifdef-y += udf_fs_i.h
>  unifdef-y += udp.h


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
