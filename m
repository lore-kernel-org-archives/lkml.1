Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZHPAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZHPAx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZHPAx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:53:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:41188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZHPAx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:53:28 -0400
Message-ID: <4A875874.20401@kernel.org>
Date: Sun, 16 Aug 2009 09:53:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Guillaume Knispel <gknispel@proformatique.com>
CC: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] poll/select: initialize triggered field of struct poll_wqueues
References: <20090815193024.121926e6@xilun.lan.proformatique.com>
In-Reply-To: <20090815193024.121926e6@xilun.lan.proformatique.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 00:53:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Knispel wrote:
> poll/select: initialize triggered field of struct poll_wqueues
> 
> The triggered field of struct poll_wqueues introduced in commit
> 5f820f648c92a5ecc771a96b3c29aa6e90013bba "poll: allow f_op->poll to
> sleep" was set to 1 in pollwake() (now __pollwake() ), tested and
> later set to 0 in poll_schedule_timeout(), but not initialized before.
> As a result when the process needs to sleep, triggered was likely to be
> non-zero even if pollwake() is not called before the first
> poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not
> be called and an extra loop calling all ->poll() would be done.
> 
> This patch initialize triggered to 0 in poll_initwait() so the ->poll()
> are not called twice before the process goes to sleep when it needs to.
> 
> Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>

Ah... nice spotting.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
