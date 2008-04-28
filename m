Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbYD1Cd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbYD1Cd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761192AbYD1CdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:33:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:37835 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873AbYD1CdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qHu+NkipgRM1Q+iCivD1n+Oj09XQduOV96zEX/Sfv7RODX490bKdkOrOVjKKGY4cyKsdspIZrQ4WMlYUJ86ODyxyLdhhvQWc8boMjaob3XldyV6YE5mXpeidR4NvNEW3jTVQDrctYxJXWJ3H3NaRZk+y6/rjVCliAMGbqQGqUE4=
Message-ID: <a8e1da0804271933i528d7c98m526195b361119dcf@mail.gmail.com>
Date: Mon, 28 Apr 2008 10:33:14 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] loop : Don't hold the lo_ctl_mutex while fput in loop_clr_fd
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <20080428021531.GA5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428021022.GB2698@darkstar.te-china.tietoenator.com>
	 <20080428021309.GZ5882@ZenIV.linux.org.uk>
	 <20080428021531.GA5882@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:15 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Apr 28, 2008 at 03:13:09AM +0100, Al Viro wrote:
>  > On Mon, Apr 28, 2008 at 10:10:22AM +0800, Dave Young wrote:
>  > > [Fixing bug 10504]
>  > >
>  > > If the bakingfile is a block device file, losetuo -d will trigger lockdep
>  > > warning of "circular locking dependency".
>  > >
>  > > open/release lock order : bdev->bd_mutex ---> lo->lo_ctl_mutex
>  > > loop_clr_fd lock order  : lo->lo_ctl_mutex ---> bdev->bd_mutex (fput)
>  > >
>  > > Don't hold the lo_ctl_mutex while fput in loop_clr_fd to fix it. It's safe
>  > > because all loop device state will be consistent here.
>  >
>  > Explain.

Hi, Maybe I have some mis-understood, thanks for pointing out in advance.

IMO the lo_ctl_mutex is for the lo->* state locking,  they are all set
to proper values before fput(filp), so I think it's safe to do that.

>
>  BTW, explain also why open() at that spot will not do interesting things
>  wrt BLKRRPART done a bit below, please.
>

open with a loop device unbound? Sorry, I don't understand.  Could you
explain a bit? Thanks

Regards
dave
