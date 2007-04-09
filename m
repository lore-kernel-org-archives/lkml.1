Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbXDIQXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbXDIQXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXDIQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:23:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53843 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbXDIQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:23:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com>
Date: Mon, 09 Apr 2007 10:20:27 -0600
In-Reply-To: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com> (Roland
	McGrath's message of "Sun, 8 Apr 2007 19:06:00 -0700 (PDT)")
Message-ID: <m11wit34fo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> I concur with Eric's assessment.  Adding new magic bits to the generic
> clone path seems like a poor way to cope with kernel threads.  I think
> it's better if kernel thread setup gets less like normal user process
> setup.  I also agree with Eric that PPID of 0 is a very natural way for
> kernel threads to be displayed.  We need to know more about the nature
> of the compatibility issue in procps to judge whether there is good
> reason to avoid changing it.

I just investigated the procps issue.  Using init_task as the parent
nothing sticks out as being wrong in /proc.

Further when I modified pstree to accept 0 as it's starting pid (from
which all else would be rooted).  All of the kernel threads showed up.

So if anything I it is a feature that kernel threads don't show up
by default in pstree (when PPID == 0).  It isn't a subtle kernel bug.

Eric
