Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbXCIAbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbXCIAbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXCIAbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:31:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXCIAbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:31:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel threads
In-Reply-To: Oleg Nesterov's message of  Thursday, 8 March 2007 19:38:44 +0300 <20070308163844.GA6638@tv-sign.ru>
Emacs: ballast for RAM.
Message-Id: <20070309003100.9893B180063@magilla.sf.frob.com>
Date: Thu,  8 Mar 2007 16:31:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your change seems fine to me.  I certainly concur that it seems insane
for init to be responsible for tasks created magically inside the
kernel.  The history I've found says that the setting to SIGCHLD was
introduced as part of "v2.5.1.9 -> v2.5.1.10", without detailed
commentary in the log.  This was probably before the auto-reaping
semantics worked as they do now.  So like the man said, at the time,
it seemed the logical thing to do.

To be paranoid, I wouldn't make this change in any stable kernel series.
It changes behavior visible to userland (init) from how it has been
consistently for five years, so, who knows, something might notice.  
The old behavior is pretty harmless, albeit changing it seems both
preferable and harmless.


Thanks,
Roland

