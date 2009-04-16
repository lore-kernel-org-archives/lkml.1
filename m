Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZDPWqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZDPWqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZDPWpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:45:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbZDPWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:45:53 -0400
Date: Thu, 16 Apr 2009 15:29:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, ryov@valinux.co.jp, s-uchida@ap.jp.nec.com,
       subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-Id: <20090416152937.b2188370.akpm@linux-foundation.org>
In-Reply-To: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
	<1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:21:14 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> Subject: [PATCH 3/9] bio-cgroup controller

Sorry, but I have to register extreme distress at the name of this. 
The term "bio" is well-established in the kernel and here we have a new
definition for the same term: "block I/O".

"bio" was a fine term for you to have chosen from the user's
perspective, but from the kernel developer perspective it is quite
horrid.  The patch adds a vast number of new symbols all into the
existing "bio_" namespace, many of which aren't related to `struct bio'
at all.

At least, I think that's what's happening.  Perhaps the controller
really _is_ designed to track `struct bio'?  If so, that's an odd thing
to tell userspace about.


> The controller bio-cgroup is used by io-throttle to track writeback IO
> and for properly apply throttling.

Presumably it tracks all forms of block-based I/O and not just delayed
writeback.


