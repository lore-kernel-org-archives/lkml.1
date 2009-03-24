Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbZCXNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbZCXNMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZCXNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:12:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbZCXNM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:12:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] fs: don't include <linux/gfp.h> to fix headers-export-check
Date: Tue, 24 Mar 2009 14:12:09 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
References: <1237888763.25315.70.camel@penberg-laptop>
In-Reply-To: <1237888763.25315.70.camel@penberg-laptop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903241412.09730.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cNfNst741Rmt+3PUvTJpXED5xrXIxDbhNf9N
 k3zaHbErYtpXHnBQxc69oPsPM/q98Q8USMSNtpj2eE7AKhSgCl
 I6BxTFy0lkxZcGDL7iP3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009, Pekka Enberg wrote:
>    
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Impact: fix build
> 
> This patch fixes a headers-export-check failure:
> 
>   /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
>   /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
>   make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
>   make[2]: *** [linux] Error 2
> 
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/fs.h |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index add95da..11fdc57 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -8,7 +8,6 @@
>  
>  #include <linux/limits.h>
>  #include <linux/ioctl.h>
> -#include <linux/gfp.h>
>  
>  /*

I think a cleaner fix would be to move the include of gfp.h into the
second #include block that is part of #ifdef __KERNEL__, as is the
only user of get_zeroed_page in there.

	Arnd <><
