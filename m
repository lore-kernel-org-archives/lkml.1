Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZASPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZASPqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 10:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZASPp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 10:45:59 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:25839 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZASPp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 10:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CDh+6/hVIOH18KcOZfh9GlnjkQQXy4iMAIuTG+Lb+S/j2uXQ+f7D7LSLeAuPL6HRgd
         0uh5LGo1e9WVHDAdhYi8lIwHl+9R6pNkgxyl3tuRsSAmUYfl2xu4o6uuuTYu9C3FXsoR
         cbQuo2ShLqUU81Gowjxcsz8BSvYBCqYdJ/r1k=
MIME-Version: 1.0
In-Reply-To: <20090117190437.GZ30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
	 <20090117190437.GZ30821@kernel.dk>
Date: Mon, 19 Jan 2009 21:15:56 +0530
Message-ID: <807b3a220901190745w79827b41u1cc9045a2ac268e5@mail.gmail.com>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Nikanth K <nikanth@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 12:34 AM, Jens Axboe <jens.axboe@oracle.com> wrote:

>
> As a quick test, could you try and increase the slice_idle to eg 20ms?
> Sometimes I've seen timing being slightly off, which makes us miss the
> sync window for the ls (in your case) process. Then you get a mix of
> async and sync IO all the time, which very much slows down the sync
> process.
>

Do you mean to say that 'ls' could not submit another request until
the previous sync request completes, but its idle window gets disabled
as it takes way too long to complete during heavy load? But when there
are requests in the driver, wont the idling be disabled anyway? Or did
you mean to increase slice_sync?

Thanks
Nikanth
