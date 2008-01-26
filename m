Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYAZPgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYAZPgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYAZPgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:36:40 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:8188 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYAZPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U8Uz+yUhXkxZK9QcWIsToGP43IvhSlVAyXzA7zU1Hy62+jCHBcFDQQ8uPijvpIsQjaFWoZqccks2dnRHh6bpRnMoOVUZsVmQmRlg9EQ3mlq54kup852D0pufDWc0epcZyKvxDFEBqDOqrdDI/otW3vGStwHqtXWD53oSTsfI6Bk=
Message-ID: <9f29ca150801260736j205b67d2jf9b57d3ac05176a2@mail.gmail.com>
Date: Sat, 26 Jan 2008 21:06:36 +0530
From: "Romit Dasgupta" <romlinux@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] Moving spinlock to struct usb_hcd
Cc: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801260021.50786.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201329041.5807.20.camel@maxwell>
	 <200801260021.50786.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
> Looking at how this lock is used, contention doesn't look likely
> to be an issue.  It's never held for long ...
yes in the general case but in usb_hcd_flush_endpoint routine it seems
to be held for longer than other routines. I agree that
usb_hcd_flush_endpoint is an infrequently called routine. Normal
systems dont have too many HCs. My computer shows 1 EHCI and 3 OHCIs
so I guess when I connect high speed devices there are less chances of
contention. With more HC this lock might be contended for.
Nevertheless, the right place for the lock seems to be inside usb_hcd.
What do you think?

>
>
> Do you have any proof that contention is an actual problem?
> Because otherwise I see no benefit to such a change.
>
I will try to see what I can find with /proc/lock_stat.

Thanks,
-Romit
