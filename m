Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbZIPXoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbZIPXoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbZIPXoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:44:13 -0400
Received: from smtp-gw3.mailanyone.net ([208.101.34.33]:37100 "EHLO
	smtp-gw3.mailanyone.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760229AbZIPXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:44:12 -0400
X-Greylist: delayed 1131 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 19:44:12 EDT
From: "Gilad Benjamini" <gilad@altornetworks.com>
To: <linux-kernel@vger.kernel.org>
Subject: epoll and closed file descriptors
Date: Wed, 16 Sep 2009 16:22:55 -0700
Message-ID: <023c01ca3724$9f90fcb0$deb2f610$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco3JJ3A4zG/sL37Rnq1Eo9A0f/YsQ==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running repeatedly into a scenario  where epoll notifies userland of
events on a closed file descriptor.
I am running a single thread application, on a single CPU machine so
multiple threads isn't the issue. 

A sample set of events that I have seen
- File descriptor (13) for a socket is closed
- epoll_wait returns with no events.
- Several epoll related calls happen
- More than 20 seconds after the "close", epoll_wait finds an event on fd 13
with EPOLLIN|EPOLLERR|EPOLLHUP.
- epoll_wait continues to report this event

Running kernel 2.6.24. Some technical problems are preventing me from trying
a newer kernel at the moment.

One more thing worth mentioning: the application uses libcurl, leading to a
situation where the file is closed before the descriptor was removed from
the epoll descriptor. The code should be able to handle that AFAIK.

Any ideas would be appreciated.
Gilad


