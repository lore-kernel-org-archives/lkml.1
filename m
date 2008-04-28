Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbYD1Rqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbYD1Rqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934202AbYD1Rqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:46:39 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:45212 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbYD1Rqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:46:38 -0400
Message-ID: <48160D7D.1030607@oracle.com>
Date: Mon, 28 Apr 2008 10:46:37 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Carl Henrik Lunde <chlunde@ping.uio.no>
CC: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk> <ed038eb20804271540q7df7ebe0p8e5c6b15c85813e0@mail.gmail.com>
In-Reply-To: <ed038eb20804271540q7df7ebe0p8e5c6b15c85813e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess it would be difficult to get close to the optimal disk schedule by
> using syslets; if a directory contains 1000 files that would require 1000
> syslets and a good I/O scheduler - that's unlikely to be feasible.

It wouldn't even get to the I/O scheduler.   The VFS stat path (see
real_lookup()) is synchronous and serialized.  Each stat will hold the
i_mutex of the parent directory while it waits for the file system's
lookup method to populate the inode from disk.

- z
