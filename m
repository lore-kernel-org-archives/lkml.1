Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXG2Hop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXG2Hop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbXG2Hog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:44:36 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48505 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222AbXG2Hof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:44:35 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <46A6F732.3080905@yahoo.com.au>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <20070722081010.GA6317@mail.ustc.edu.cn>
	 <1185093236.6344.87.camel@localhost.localdomain>
	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>
	 <46A6DD7F.1050505@yahoo.com.au> <1185344325.7105.91.camel@perkele>
	 <46A6F732.3080905@yahoo.com.au>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 03:44:33 -0400
Message-Id: <1185695073.6665.6.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-25-07 at 17:09 +1000, Nick Piggin wrote:
> Eric St-Laurent wrote:
> > I test this on my main system, so patches with basic testing and
> > reasonable stability are preferred. I just want to avoid data corruption
> > bugs. FYI, I used to run the -rt tree most of the time.
> 
> OK here is one which just changes the rate that the active and inactive
> lists get scanned. Data corruption bugs should be minimal ;)
> 

Nick,

I have tried your patch with my test case, unfortunately it doesn't
help.

Numbers did vary a little bit more, and it seemed drop_caches was not
working as well as usual (used between the runs).

Also, overall the runs took about .1s more to complete.


Linux 2.6.23-rc1-nick PREEMPT x86_64

Base test:

1st run: 0m9.123s
2nd run: 0m3.565s
3rd run: 0m3.553s
4th run: 0m3.565s

Reading a large file test:

1st run: 0m9.146s
2nd run: 0m3.560s
`/tmp/large_file' -> `/dev/null'
3rd run: 0m19.759s
4th run: 0m3.515s

Copying (using cp) a large file test:

1st run: 0m9.085s
2nd run: 0m3.522s
`/tmp/large_file' -> `/tmp/large_file.copy'
3rd run: 0m9.977s
4th run: 0m3.518s


Anyway, what is the theory behind the patch?


- Eric


