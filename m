Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXD0HYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXD0HYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXD0HYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:24:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41373 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbXD0HYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:24:36 -0400
Date: Fri, 27 Apr 2007 10:24:34 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177657400.4737.121.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.64.0704271007010.22187@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <1177617379.4737.29.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI> 
 <1177654110.4737.91.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> 
 <1177655661.4737.106.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270939460.20493@sbz-30.cs.Helsinki.FI>
 <1177657400.4737.121.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> User input doesn't account for all system activity. Think of cron jobs
> or user initiated jobs that may have started before the cycle began.

Yes, but the _user_ did not start them so they didn't lose any work. See, 
it might or might not be important but that's something the _userspace_ 
has much more knowledge than the kernel ever will.

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> Noooo! If the user looses data, the user will be concerned and we should
> be. I for one would do my best to avoid using software that loses my
> data for me. I wouldn't care if you said "Well, it's your fault. You
> lost the data." From my perspective as a user, I didn't lose the data,
> some part of the computer's OS did.

You are looking at snapshot/shutdown from kernel and user experience point 
of view at the same time which causes confusion here.

Let me repeat: it is _absolutely no concern_ of the _kernel_ whether you 
resume to a snapshot that does not contain all your precious data. The 
kernel doesn't care one bit!

That being said, the _userspace solution_ obviously needs to take this 
into account by blocking user input, making filesystems read-only, and 
maybe even blocking certain background processes (cron and beagle indexing 
come into mind).

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> Sorry, but I just don't believe filesystems should need to throw away
> metadata post resume. If we let data be changed after snapshotting (or
> ourselves cause it to be changed), we're the ones that are broken. Our
> snapshot is out of date and the expectations of userspace programs that
> were snapshotted will be out of date. Just imagine, for example, a
> userspace program that is snapshotted, then reads and deletes a
> temporary file. After the snapshot restore, it's running again. But
> wait, we can't read or delete the file again because it's already gone.
> Life just gets more complicated and confusing this way.

It doesn't. We can either make the filesystem read-only or, surprise, 
surprise, make a _snapshot_ of the filesystem!

And while the points you raised are important for the full 
end-user solution, it is absolutely not interesting to snapshot_system(). 
The only thing it needs to guarantee is a consistent snapshot that we can 
resume later.

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> Maybe, but I'd still rather be encouraging!

You are. Perhaps you just don't know it yet. ;-)

				Pekka
