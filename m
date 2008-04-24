Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYDXVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYDXVH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYDXVHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:07:12 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:37325 "EHLO
	mfe03.nfit.au.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYDXVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:07:11 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 17:07:11 EDT
To: linux-kernel@vger.kernel.org
Subject: stat benchmark
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 24 Apr 2008 22:59:10 +0200
Message-ID: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At

    http://www.daimi.au.dk/~sandmann/stat-benchmark.c

there is a simple program that will measure the time it takes to stat
every file in the current directory with a cold cache.

This is essentially what applications do in a number of common cases
such as "ls -l", nautilus opening a directory, or an "open file"
dialog being showed.

Unfortunately, performance of that operation kinda sucks. On my system
(ext3), it produces:

    c-24-61-65-93:~% sudo ./a.out 
    Time to readdir(): 0.307671 s
    Time to stat 2349 files: 8.203693 s

8 seconds is about 80 times slower than what a user perceives as
"instantly" and slow enough that we really should display a progress
bar if it can't be fixed.

So I am looking for ways to improve this.

Under the theory that disk seeks are killing us, one idea is to add a
'multistat' system call that would allow statting of many files at a
time, which would give the disk scheduler more to work with. 

Possibly the same thing would need to be done for the getxattr
information.

Does this sound like a reasonable idea?


Thanks,
Soren
