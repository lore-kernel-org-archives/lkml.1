Return-Path: <linux-kernel-owner+w=401wt.eu-S1423014AbXDZA0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423014AbXDZA0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423011AbXDZA0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:26:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422997AbXDZA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:26:21 -0400
Date: Wed, 25 Apr 2007 17:24:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, arnd@arndb.de, maxextreme@gmail.com,
       gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-Id: <20070425172447.1576c399.akpm@linux-foundation.org>
In-Reply-To: <20070425143011.57247c1d.akpm@linux-foundation.org>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 14:30:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> But that only applies to things which I merge.  There's heaps of stuff
> coming in via the git trees which is obviously inadequately reviewed - look
> at all the instances of open-coded kernel_thread() which were merged after
> the kthread() API was introduced, for example.
> 
> 
> And other basic stuff like "use mutexes, not semaphores":
> 
> box:/usr/src/25> grep '^+.*[    ]down[  ]*[(]' patches/git-*.patch | wc -l
> 32
> 
> 
> 
> Ever wonder where all those whitespace bugs are coming from?
> 
> box:/usr/src/25> grep '^+.*[    ]if[(]' patches/git-*.patch | wc -l
> 265
> box:/usr/src/25> grep '^+.*[    ]while[(]' patches/git-*.patch | wc -l  
> 35
> 
> 
> Code which use spaces where it should be using tabs?
> 
> box:/usr/src/25> grep '^+        ' patches/git-*.patch | wc -l
> 1346
> 

It would be neat if someone could create and maintain a new
scripts/spot-common-mistakes.  Feed it a unified diff and it would complain
about newly-added code (and only newly-added code) which has busted
whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.

It would need to be fairly simple and easily-extensible, as I can
imagine quite a few things getting added to it.

(Imagines a procmail rule which just bounces the email if
spot-common-mistakes failed)


> 
> Heaven knows how many more serious problems are being snuck into the tree
> via this route.

But it won't solve this problem.
