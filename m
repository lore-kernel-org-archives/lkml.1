Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYKMNnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYKMNnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYKMNmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:42:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55251 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYKMNmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:42:51 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491C2A63.1030804@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 22:23:47 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org> <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu> <E1L0bP7-0006nJ-7n@pomaz-ex.szeredi.hu> <491C2A63.1030804@kernel.org>
Message-Id: <E1L0cSz-0006xF-0O@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 14:42:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> We don't need POLL_RELEASE

What happens on timeout?  Do we just let userspace continue polling
the file descriptor, and then ignore the notification?

>  but we still need POLL-reply (to request) to
> send revents.  We can put that into notification too.  Hmmm... Yeah,
> that could be simpler for FUSE servers.  I'll venture that way.

Then in fact the notification could just become the reply:

<- POLL-request (sent with request_send_nowait())
...
-> POLL-reply  (calls req->end())

So there won't even be a need to implement notification (we'll need
that for other things in the future) simplifying things even further.
Even if we want to cancel the request because of a timeout, that could
be done with the existing INTERRUPT request.

Miklos
