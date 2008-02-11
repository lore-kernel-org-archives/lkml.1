Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYBKL6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYBKL6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBKL6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:58:33 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:56977 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbYBKL6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:58:33 -0500
X-Greylist: delayed 1616 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 06:58:32 EST
Subject: Re: Linux 2.6.22.18
From: Matthew Keenan <matt@opcode-solutions.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080211074346.GB23195@kroah.com>
References: <20080211074313.GA23195@kroah.com>
	 <20080211074346.GB23195@kroah.com>
Content-Type: text/plain
Organization: OpCode Solutions
Date: Mon, 11 Feb 2008 11:31:25 +0000
Message-Id: <1202729485.24584.5.camel@bazbox.opcode-solutions.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Originating-Pythagoras-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-10 at 23:43 -0800, Greg Kroah-Hartman wrote:
> diff --git a/Makefile b/Makefile
> index 6a949eb..99c5e87 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 22
> -EXTRAVERSION = .17
> +EXTRAVERSION = .18
>  NAME = Holy Dancing Manatees, Batman!
>  
>  # *DOCUMENTATION*
> diff --git a/fs/splice.c b/fs/splice.c
> index e263d3b..dbbe267 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1182,6 +1182,9 @@ static int get_iovec_page_array(const struct iovec __user *iov,
>  		if (unlikely(!base))
>  			break;
>  
> +		if (!access_ok(VERIFY_READ, base, len))
> +			break;
> +
>  		/*
>  		 * Get this base offset and number of pages, then map
>  		 * in the user pages.

Maybe I'm missing something here, but is there are reason that the patch
for 2.6.22 differs from 2.6.2[34]? The "if(unlikely(!base))" is removed
in the latter.

Matt


