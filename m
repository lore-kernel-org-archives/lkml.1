Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXFDB0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXFDB0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXFDB0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:26:01 -0400
Received: from quechua.inka.de ([193.197.184.2]:46294 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXFDB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:26:00 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <e7ca40f70706031805h56da4c3ag2dd0e902430785cc@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hv1KY-0003Kb-00@calista.eckenfels.net>
Date: Mon, 04 Jun 2007 03:25:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <e7ca40f70706031805h56da4c3ag2dd0e902430785cc@mail.gmail.com> you wrote:
> In short, I'm distributing logs in realtime for about 600,000
> websites.  The sources of the logs (http, ftp, realmedia, etc) are
> flexible, however the base framework was build around a large cluster
> of webservers.  The output can be to several hundred thousand files
> across about two dozen filers for user consumption - some can be very
> active, some can be completely inactive.

Asuming you have multiple request log summary files, I would just run
multiple "splitters".

> You can certainly open the file, but not block on the call to do it.
> What confuses me is why the kernel would "block" for 415ms on an open
> call.  Thats an eternity to suspend a process that has to distribute
> data such as this.

Because it has to, to return the result with the given API. 

But If you would have a async interface, the operation would still take that
long and your throughput will still be limited by the opens/sec your filers
support, or?

> Except I cant very well keep 600,000 files open over NFS.  :)  Pool
> and queue, and cycle through the pool.  I've managed to achieve a
> balance in my production deployment with this method - my email was
> more of a rant after months of trying to work around a problem (caused
> by a limitation in system calls),

I agree that a unified async layer is nice from the programmers POV, but I
disagree that it would help your performance problem which is caused by NFS
and/or NetApp (and I wont blame them).

Gruss
Bernd
