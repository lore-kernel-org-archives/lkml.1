Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYA1EUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYA1EUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYA1EUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:20:38 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:46435 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYA1EUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IaMH/cSQaxaSMRiwnyBxYzOtkXDj9naB/j317vyiAWDlma3/Mje3pQsWXcJi8imfZodYGWBFnUybo7Sm1bT8ZHh1jhvlqVUS8+n52cxANHXtLj4I5lynGZKezFMEVeHdcd9Tv7h7kfywIfYiwGBDEyBqlco2dtSTfjoNNY+h89k=
Message-ID: <9f29ca150801272020t2ced46b6ka8e7890dfbe1e1a8@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:50:36 +0530
From: "Romit Dasgupta" <romlinux@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] Moving spinlock to struct usb_hcd
Cc: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <9f29ca150801260736j205b67d2jf9b57d3ac05176a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201329041.5807.20.camel@maxwell>
	 <200801260021.50786.david-b@pacbell.net>
	 <9f29ca150801260736j205b67d2jf9b57d3ac05176a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
                 Should I go ahead and submit the patch with the usual
"signed-off" thingie? Or is it totally useless patch that is going to
be ignored?

Thanks,
-Romit


On Jan 26, 2008 9:06 PM, Romit Dasgupta <romlinux@gmail.com> wrote:
> >
> >
> > Looking at how this lock is used, contention doesn't look likely
> > to be an issue.  It's never held for long ...
> yes in the general case but in usb_hcd_flush_endpoint routine it seems
> to be held for longer than other routines. I agree that
> usb_hcd_flush_endpoint is an infrequently called routine. Normal
> systems dont have too many HCs. My computer shows 1 EHCI and 3 OHCIs
> so I guess when I connect high speed devices there are less chances of
> contention. With more HC this lock might be contended for.
> Nevertheless, the right place for the lock seems to be inside usb_hcd.
> What do you think?
>
> >
> >
> > Do you have any proof that contention is an actual problem?
> > Because otherwise I see no benefit to such a change.
> >
>
> I will try to see what I can find with /proc/lock_stat.
>
> Thanks,
> -Romit
>
