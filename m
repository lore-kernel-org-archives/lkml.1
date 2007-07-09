Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbXGICGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbXGICGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXGICGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:06:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21816 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbXGICGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JEkdSba7On6sfC7EPU/tsXh4hjGgDI4MdnwnQ5G7Uxh2LvwclCT/qAxek3KHbXWMEUPUevqYAyvcINUw91JHUD2ATM2bwyKB5KCsqJWal4GlNl14MKkjMXBWbCiYE/A0l6ELhoX2yS3ntsX5XWbgh+ef0Borx69bfUdzegOk+/8=
Date: Mon, 9 Jul 2007 06:06:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravenborg.org
Subject: Re: [PATCH] fixup binutils printing from scripts/ver_linux
Message-ID: <20070709020606.GA5761@martell.zuzino.mipt.ru>
References: <200707090147.58611.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707090147.58611.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 01:47:58AM +0200, Jesper Juhl wrote:
> I just found that scripts/ver_linux does not print the binutils version 
> properly on my Slackware 12.0 system.

> --- a/scripts/ver_linux
> +++ b/scripts/ver_linux
> @@ -21,9 +21,8 @@ gcc --version 2>&1| grep gcc | awk \
>  make --version 2>&1 | awk -F, '{print $1}' | awk \
>        '/GNU Make/{print "Gnu make              ",$NF}'
>  
> -ld -v | awk -F\) '{print $1}' | awk \
> -'/BFD/{print "binutils              ",$NF} \
> -/^GNU/{print "binutils              ",$4}'
> +echo "binutils               $(ld -v | awk -F \) \
> +{'print $2'} | tr -d ' ')"

NAK. It starts reporting here empty binutils field.
FWIW,

	$ ld -v
	GNU ld version 2.16.1

