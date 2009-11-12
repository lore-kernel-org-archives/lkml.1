Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZKLKhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZKLKhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZKLKhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:37:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZKLKhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:37:24 -0500
Date: Thu, 12 Nov 2009 11:36:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091112103639.GB24684@elte.hu>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
 <4AF9BE3A.40409@kernel.org>
 <20091110193705.GA9011@elte.hu>
 <4AF9C402.9040800@kernel.org>
 <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
 <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu>
 <4AFAAC32.4020104@kernel.org>
 <20091111195751.GA13574@elte.hu>
 <4AFBDF43.3010703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFBDF43.3010703@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hmmm... The thing is that the nesting isn't that deep there and 
> breaking string in the middle is something we do quite often.  What 
> checkpatch warning did you see?

( i did not run checkpatch over your commit - i just assumed that the 
  ugliness was a checkpatch artifact. )

Breaking strings mid-sentence is something we try not to do. (If you 
know about places that do it 'quite often' then those places need fixing 
too.)

The biggest problem with it s that it breaks git grep. If someone sees 
this message in the log:

  PERCPU: allocation failed, size=1024 align=32, failed to extend area map of reserved chunk

and types the obvious:

  git grep 'failed to extend area map of reserved chunk'

the git-grep comes up empty because the string was needlessly broken in 
mid-sentence. Which is a confusing result and which causes people to 
waste time trying to figure out where the message came from.

The other messages in this function are fine btw, for example:

  git grep 'failed to populate'

will come up with the right place.

( There are also other reasons why we dont break strings mid-sentence - 
  it's also less readable to have it on two lines. )

	Ingo
