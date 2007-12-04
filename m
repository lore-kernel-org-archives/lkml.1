Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXLDJGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXLDJGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLDJGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:06:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:15435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXLDJGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:06:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QFYkv0+x182wAwRwlhjkkrwQINTVD+brdQ1ig+VvjBkbq+Xv8/3ttRDw1qWKgQMvB
	radkHZnTwkndITfIYOsww==
Message-ID: <532480950712040106r144ed43m5cb77cc394e2ec8a@mail.gmail.com>
Date: Tue, 4 Dec 2007 01:06:06 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Chris Mason" <chris.mason@oracle.com>
In-Reply-To: <396386387.18082@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128192957.511EAB8310@localhost> <396296481.07368@ustc.edu.cn>
	 <532480950711291216l181b0bej17db6c42067aa832@mail.gmail.com>
	 <396386387.18082@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 5:32 PM, Fengguang Wu <wfg@mail.ustc.edu.cnwrote:
> > On Nov 28, 2007 4:34 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > Could you demonstrate the situation? Or if I guess it right, could it
> > > be fixed by the following patch?

Feng I am sorry to have been mistaken but I reran my tests and I am
now finding that the patch you gave me is NOT fixing the problem.  The
patch I refer to is the one you posted on this thread that adds a
requeue_io in __sync_single_inode.

I tarred up my test code. It is still in very rough shape but it can
reproduce the issue. You can find it here:

http://neverthere.org/mhr/wb/wb-test.tar.bz2

Just make the test and run it with the args "-duration 0:5:0
-starvation". You must be root so it can set some sysctl values.

> One major concern could be whether a continuous writer dirting pages
> at the 'right' pace will generate a steady flow of write I/Os which are
> _tiny_hence_inefficient_.
>
> So it's not a problem in *theory* :-)
>
> > I will post this change for 2.6.24 and list Feng as author. If that's
> > ok with Feng.

I am going to try to track down what is up in 2.6.24 and see if I can
find a less dramatic fix than my tree patch for the short term. If you
get a chance to reproduce the problem with my test on your patch that
would rock.

I still would like to see my full patch accepted into 2.6.25. A patch
should be arriving shortly that will incorporate my larger patch and
Qi Yong's fix for skip-writing-data-pages-when-inode-is-under-i_sync.
http://www.gossamer-threads.com/lists/linux/kernel/849493

As always thanks for your patience,

mrubin
