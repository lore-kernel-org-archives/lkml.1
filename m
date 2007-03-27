Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbXC0TAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbXC0TAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934188AbXC0TAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:00:48 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45153 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187AbXC0TAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:00:48 -0400
To: linux@horizon.com
CC: akpm@linux-foundation.org, linux@horizon.com, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
In-reply-to: <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Tue, 27 Mar 2007 20:55:51 +0200)
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <20070327184227.13923.qmail@science.horizon.com> <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HWGtr-0004ZN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 21:00:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I agree that msync(MS_ASYNC) has no semantics if time is ignored.
> > But it's a useful way to tell the OS that the page is not going
> > to be dirtied again.
> 
> Just to clarify, here's the header comment for sys_msync():
> 
> /*
>  * MS_SYNC syncs the entire file - including mappings.
>  *
>  * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
>  * Nor does it marks the relevant pages dirty (it used to up to 2.6.17).
>  * Now it doesn't do anything, since dirty pages are properly tracked.
>  *
>  * The application may now run fsync() to
>  * write out the dirty pages and wait on the writeout and check the result.
>  * Or the application may run fadvise(FADV_DONTNEED) against the fd to start
>  * async writeout immediately.
>  * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
>  * applications.
>  */
> 
> It's actually wrong about FADV_DONTNEED, which I think doesn't start
> writeout either.  So there you have it ;)

Sorry, FADV_DONTNEED _does_ seem to start writeout, but it does it
indiscriminately, not just on the specified range.  That should be
easy to fix though.

Miklos
