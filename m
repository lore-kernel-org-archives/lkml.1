Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbXGVTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbXGVTJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbXGVTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:09:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759610AbXGVTJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:09:09 -0400
Date: Sun, 22 Jul 2007 12:09:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jon Smirl <jonsmirl@gmail.com>
cc: Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git help for kernel archeology, suppress diffs caused by CVS
 keyword expansion
In-Reply-To: <9e4733910707221148g69d7600bk632abb7452ce9c7c@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707221205080.3607@woody.linux-foundation.org>
References: <9e4733910707221148g69d7600bk632abb7452ce9c7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jul 2007, Jon Smirl wrote:
>
> It would really be useful if git diff had an option for suppressing
> diffs caused by CVS keyword expansion.

I really think it's not a "git diff" issue, but it might be a "import" 
issue.

IOW, I think you'd be a *lot* better off just not importing those things 
in the first place (which is what CVS does internally), or possibly 
importing them as two trees (ie you'd have the "non-log" version and the 
"log expansion" version, so that you can track and compare both).

Doing the thing at "diff" time is certainly possible, but this is simply 
much better done as a totally independent preprocessing phase. The diff 
handling is already some of the more complex parts (and very central), it 
would be much simpler and efficient to not try to make that thing fancier, 
and instead solve the problem at the front-end.

			Linus
