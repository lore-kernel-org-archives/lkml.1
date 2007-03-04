Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbXCDEgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbXCDEgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 23:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCDEgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 23:36:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53765 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXCDEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 23:35:59 -0500
Date: Sat, 3 Mar 2007 20:35:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303203556.8648c9a2.akpm@linux-foundation.org>
In-Reply-To: <75b66ecd0703031835j5ff2846fpd4761a89f67fc2f1@mail.gmail.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<75b66ecd0703031716k5b9fd96br9ecd93f1fc3a6032@mail.gmail.com>
	<20070303173933.9f46459c.akpm@linux-foundation.org>
	<75b66ecd0703031835j5ff2846fpd4761a89f67fc2f1@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 21:35:59 -0500 "Lee Revell" <rlrevell@joe-job.com> wrote:

> On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > But yes, updatedb's pagecache usage will be mainly metadata, and this tool
> > doesn't address metadata pagecache, although it could do so.
> >
> 
> With no kernel changes?  How?  I can't find an equivalent API to
> posix_fadvise() for metadata.
> 

We can use mincore and fadvise against /dev/sda1, too.

mincore's linear search would hurt but you could just run fadvise
regularly.  A lot of the blockdev pagecache is pretty useless anyway: we've
already copied it much of it into dentries and inodes, and some of ext2/3/4's
pagecache is already pinned by the fs.

