Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYATPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYATPmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 10:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYATPmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 10:42:08 -0500
Received: from as4.cineca.com ([130.186.84.251]:37774 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYATPmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 10:42:07 -0500
Message-ID: <47936BC1.9060805@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com> <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk>
In-Reply-To: <20080120143239.GS6258@kernel.dk>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Sun, 20 Jan 2008 16:41:54 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Your approach is totally flawed, imho. For instance, you don't want a
> process to be able to dirty memory at foo mb/sec but only actually
> write them out at bar mb/sec.

Right. Actually my problem here is that the processes that write out
blocks are different respect to the processes that write bytes in
memory, and I would be able to add limits on those processes that are
dirtying memory.

> The noop-iosched changes are also very buggy. The queue back pointer
> breaks reference counting and the task pointer storage assumes the task
> will also always be around. That's of course not the case.

Yes, this really need a lot of fixes. I simply posted the patch to know
if such approach (in general) could have sense or not.

> IOW, you are doing this at the wrong level.
> 
> What problem are you trying to solve?

Limiting block I/O bandwidth for tasks that belong to a generic cgroup,
in order to provide a sort of a QoS on block I/O.

Anyway, I'm quite new in the wonderful land of the I/O scheduling, so
any help is appreciated.

Thanks,
-Andrea
