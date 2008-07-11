Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYGKT4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYGKT4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYGKT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:56:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGKT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fp0nAg5ew9gcJ3FZR1F56yAWOgHnJUd2dH80dGma30FITeuREsAymD08UWq/C4NkVf
         oQSIPLXj5OSOSCcssN1KDqSPpFbOPV/2qjL5kgwSint9kxSYbn/AOMFzDDiHAQvpyRo6
         wJWvxUH0WSfubhsUeqtmTsS0rD/2QBxs+XaRw=
Date: Fri, 11 Jul 2008 23:53:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arjan@linux.intel.com, akpm@osdl.org
Subject: Re: + use-warn-in-fs-proc.patch added to -mm tree
Message-ID: <20080711195305.GA29379@martell.zuzino.mipt.ru>
References: <200807111851.m6BIpLra031332@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111851.m6BIpLra031332@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 11:45:40AM -0700, akpm@linux-foundation.org wrote:
> --- a/fs/proc/generic.c~use-warn-in-fs-proc
> +++ a/fs/proc/generic.c
> @@ -806,12 +806,9 @@ continue_removing:
>  	if (S_ISDIR(de->mode))
>  		parent->nlink--;
>  	de->nlink = 0;
> -	if (de->subdir) {
> -		printk(KERN_WARNING "%s: removing non-empty directory "
> +	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
>  			"'%s/%s', leaking at least '%s'\n", __func__,
>  			de->parent->name, de->name, de->subdir->name);
> -		WARN_ON(1);
> -	}

It would be nice to call it WARN_IF but OK anyway.

