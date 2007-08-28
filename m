Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXH1Tcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXH1Tcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXH1TTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:19:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53216 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762911AbXH1TTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:19:43 -0400
Date: Tue, 28 Aug 2007 21:21:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ver_linux is [censored]
Message-ID: <20070828192104.GA32104@uranus.ravnborg.org>
References: <20070821071938.GA17761@localhost.sw.ru> <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com> <20070822005236.GF21089@ftp.linux.org.uk> <200708220311.56736.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708220311.56736.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 03:11:56AM +0200, Jesper Juhl wrote:
> 
> Fix ver_linux glibc version printing (for real this time)
> 
> Alexey Dobriyan reported that commit 
> 4a645d5ea65baaa5736bcb566673bf4a351b2ad8
> broke ver_linux when glibc has a 3 digit 
> version number, and proposed a patch.
> Al Viro then suggested a simpler way to 
> solve the problem which I've then simply 
> put into patch form.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> Signed-off-by: Al Viro <viro@ftp.linux.org.uk>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  scripts/ver_linux |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/ver_linux b/scripts/ver_linux
> index 8f8df93..5a16bad 100755
> --- a/scripts/ver_linux
> +++ b/scripts/ver_linux
> @@ -65,9 +65,8 @@ isdnctrl 2>&1 | grep version | awk \
>  showmount --version 2>&1 | grep nfs-utils | awk \
>  'NR==1{print "nfs-utils             ", $NF}'
>  
> -ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
> --e 's/\.so$//' | sed -e 's/>//' | \
> -awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
> +echo -n "Linux C Library        "
> +sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' < /proc/self/maps
>  
>  ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
>  'NR==1{print "Dynamic linker (ldd)  ", $NF}'
> 

Applied.

	Sam
