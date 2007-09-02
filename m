Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbXIBT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbXIBT5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXIBT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:57:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59549 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXIBT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:57:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<200709020344.51437.rob@landley.net> <46DA7A4C.6080501@zytor.com>
	<200709020605.00782.rob@landley.net>
Date: Sun, 02 Sep 2007 13:56:33 -0600
In-Reply-To: <200709020605.00782.rob@landley.net> (Rob Landley's message of
	"Sun, 2 Sep 2007 06:05:00 -0500")
Message-ID: <m1d4x0zvri.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:
>
> If you're going to add a new api, you might as well go with the sysctl-by-name 
> patch above, which looks reasonably small and simple to me from a very quick 
> glance at a 2.6.0-era patch.
>
> The advantage of breaking /proc/sys into a separate filesystem doesn't 
> introduce a new API (although possibly a new line in the init scripts), so 
> existing software doesn't have to change to use it, which is good.  It 
> increases orthogonality and granularity, which embedded guys like me are 
> generally in favor of. :)

- I think sysctlfs makes sense.
- I think all that is left is superblock handling and some backward
  compatibility magic. (Using the follow_link trick to automatically
  mount /proc/sys)

All of the rest of the code pretty much lives in fs/proc/proc_sysctl.c
already.

I have some other priorities to deal with first but if no one does the
work before I get there I will probably implement that eventually.

Eric
