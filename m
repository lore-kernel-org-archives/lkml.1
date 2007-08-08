Return-Path: <linux-kernel-owner+w=401wt.eu-S934474AbXHHOaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbXHHOaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXHHOaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:30:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:64381 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXHHOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=jdYvBBfdOzShW56BtLwWnUWtGCqmULvhLkmdzlCrsgq/WeED/4QxJXXioHkXbXrVfww+1SxspZS1UfuL/xjWytAwbCyKyBN310WfwDU0xLRot0UvclLRQJFSV+GWrHDnhfVP+4Cah0b4wxMcHbYm0nL31WLK0l0d6lUWvtjNdfg=
Date: Wed, 8 Aug 2007 16:26:28 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>, paulkf@microgate.com,
       linux-kernel@vger.kernel.org
Subject: Re: Serial buffer memory leak
Message-ID: <20070808142628.GA14494@slug>
References: <200708081158.06843.laurentp@cse-semaphore.com> <20070808144532.5e3a1998@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808144532.5e3a1998@the-village.bc.nu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 02:45:32PM +0100, Alan Cox wrote:
> > I'm not familiar enough with the tty code to decide what the proper fix should 
> > be. I'll try to write a patch if someone could point me in the right 
> > direction.
> 
> Something like this perhaps ?
> 
[....]
> - *	flush all the buffers containing receive data
> + *	flush all the buffers containing receive data. Caller must
> + *	hold the buffer lock and must have ensured no parallel flush to
> + *	ldisc is running.
>   *
>   *	Locking: none
                 ^^^^
>   */
Isn't the comment a bit misleading here? The caller must hold tty->buf.lock.

Frederik
