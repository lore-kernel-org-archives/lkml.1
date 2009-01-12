Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZALWJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZALWJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZALWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:06:24 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:50475 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925AbZALWGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:06:22 -0500
Subject: Re: Linux 2.6.29-rc1
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Jan 2009 23:05:53 +0100
Message-Id: <1231797954.2797.11.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lør, 10 01 2009 kl. 16:13 -0800, skrev Linus Torvalds:
> The merge window is over, and while it is quite possible that I missed a 
> few merge requests in the crazy week that is behind us, apart from those 
> we should now have most of the bulk of 2.6.29 merged up. And now it's just 
> a small matter of making sure it's all stable and ready to go.
> 
> I wanted to release -rc1 with time enough that by the time I'm on my way 
> to LCA next weekend, we'd have an -rc2 too, and the worst fallout from 
> -rc1 would be fixed.

Linus and Jonathan,

would you be so kind to make some noise about the reiserfs issue that
exists between c1eaa26 and 2f1169e?

Booting a kernel in that window results in a semi-broken reiserfs file
system (can boot but not build a new kernel etc.) and a fsck is needed
for complete restoration of consistency of fs. See also the original
report of the problem [1].

2.6.29-rc1 has the fix, but people like me that are doing bisections in
the 2.6.28..2.6.29-rc1 window are likely to run into the problem, and
should run something like the following after each git bisect bad/good

git rev-list HEAD | grep -q c1eaa26 && \
  (git rev-list HEAD | grep -q 2f1169e || git cherry-pick -n 2f1169e)

[1] http://marc.info/?l=linux-kernel&m=123106871227339&w=2


Simon Holm Thøgersen

