Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbYDYXJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbYDYXJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYDYXJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:09:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17624 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYDYXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LxLBbPPxA19/wdswq0IaXyfCDuVTREOVpvbs2eOpqkhn5zvwBeVNw40Rv0Bm25mxTKjxDLQ/6RXWYNWgzV1qFe0+gtqnokalBkRV3M8na6ibxSr5zYfyKxYIR0K22RQXSonjIxkGT6aMYLa7Vs7XFZTKiMdrnPJnOfoJvQpdpYw=
Message-ID: <524f69650804251609j1b1d1161w18999f4692f130d1@mail.gmail.com>
Date: Fri, 25 Apr 2008 18:09:35 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-pre build errors
Cc: lkml <linux-kernel@vger.kernel.org>, "David Miller" <davem@davemloft.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200804260042.32391.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650804251533i6919593dk3a99e2e134e338c9@mail.gmail.com>
	 <200804260042.32391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As expected, this patch resolved the link error.

On Fri, Apr 25, 2008 at 5:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 26 of April 2008, Steve French wrote:
>  > From today's current 2.6. kernel git tree - build included compile
>  > errors in joystick support.  After disabling joystick support, I still
>  > get at least one link error:
>  >
>  > ERROR: "__locks_copy_lock" [fs/lockd/lockd.ko] undefined!
>
>  Please try this:
>
>  __locks_copy_lock has to be exported, because it's used in lockd,
>  which may be built as a module.
>
>  Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>  ---
>   fs/locks.c |    2 ++
>   1 file changed, 2 insertions(+)
>
>  Index: linux-2.6/fs/locks.c
>  ===================================================================
>  --- linux-2.6.orig/fs/locks.c
>  +++ linux-2.6/fs/locks.c
>  @@ -237,6 +237,8 @@ void __locks_copy_lock(struct file_lock
>         new->fl_lmops = NULL;
>   }
>
>  +EXPORT_SYMBOL(__locks_copy_lock);
>  +
>   void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
>   {
>         locks_release_private(new);
>
>



-- 
Thanks,

Steve
