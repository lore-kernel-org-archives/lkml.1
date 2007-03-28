Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXC1JuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXC1JuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXC1JuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:50:18 -0400
Received: from science.horizon.com ([192.35.100.1]:11561 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934031AbXC1JuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:50:16 -0400
Date: 28 Mar 2007 05:50:14 -0400
Message-ID: <20070328095014.20945.qmail@science.horizon.com>
From: linux@horizon.com
To: nickpiggin@yahoo.com.au
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Cc: akpm@linux-foundation.org, linux@horizon.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, miklos@szeredi.hu
In-Reply-To: <460A201C.3070405@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But if you didn't notice until now, then the current implementation
> must be pretty reasonable for you use as well.

Oh, I definitely noticed.  As soon as I tried to port my application
to 2.6, it broke - as evidenced by my complaints last year.  The
current solution is simple - since it's running on dedicated boxes,
leave them on 2.4.

I've now got the hint on how to make it work on 2.6 (sync_file_range()),
so I can try again.  But the pressure to upgrade is not strong, so it
might be a while.

You may recall, this subthread started when I responding to "the
only reason to use msync(MS_ASYNC) is to update timestamps" with a
counterexample.  I still think the purpose of the call is a hint to the
kernel that writing to the specified page(s) is complete and now would be
a good time to clean them.  Which has very little to do with timestamps.

Now, my application, which leaves less than a second between the MS_ASYNC
and a subsequent MS_SYNC to check whether it's done, broke, but I can
imagine similar cases where MS_ASYNC would remain a useful hint to reduce
the sort of memory hogging generally associated with "dd if=/dev/zero"
type operations.

Reading between the lines of the standard, that seems (to me, at least)
to obviously be the intended purpose of msync(MS_ASYNC).  I wonder if
there's any historical documentation describing the original intent
behind creating the call.
