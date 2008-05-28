Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYE1QJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYE1QJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYE1QJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:09:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYE1QJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:09:23 -0400
Date: Wed, 28 May 2008 09:06:37 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Message-ID: <20080528160637.GB3851@kroah.com>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org> <20080520172139.GA11666@kroah.com> <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com> <20080526235934.8a28bfba.akpm@linux-foundation.org> <20080528154840.GJ22636@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528154840.GJ22636@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 09:48:40AM -0600, Matthew Wilcox wrote:
> On Mon, May 26, 2008 at 11:59:34PM -0700, Andrew Morton wrote:
> > If that semaphore is being used as a mutex then we should convert it to
> > a mutex (dammit).
> 
> Right.
> 
> > Leaving it implemented as a semphore is not the proper way of
> > suppressing the lockdep warnings.  It would be better to convert it to
> > a mutex then add suitable (and suitably commented) open-coded lockdep
> > annotations to suppress the runtime warnings.
> 
> We don't even have to go that far.  Here's all that's needed:
> 
> diff -u a/drivers/base/class.c b/drivers/base/class.c
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -134,7 +134,7 @@
>  	}
>  }
>  
> -int class_register(struct class *cls)
> +int __class_register(struct class *cls, struct lock_class_key *key)

Sorry, this will not work properly, as class_create() is now more
commonly called, and it calls class_register() from within the driver
core.  So there would be a lot of classes with the same "key" because of
this.

So try changing class_create also.

thanks,

greg k-h
