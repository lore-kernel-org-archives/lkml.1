Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbXK2Rj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbXK2Rj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbXK2Rju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:39:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53880 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbXK2Rjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:39:49 -0500
Date: Thu, 29 Nov 2007 17:39:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 4/6] x86-64 ptrace get/putreg current task
Message-ID: <20071129173944.GB556@infradead.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004118.D317B26F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129004118.D317B26F8E7@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 04:41:18PM -0800, Roland McGrath wrote:
> 
> This generalizes the getreg and putreg functions so they can be used on the
> current task, as well as on a task stopped in TASK_TRACED and switched off.
> This lays the groundwork to share this code for all kinds of user-mode
> machine state access, not just ptrace.

Not sure it's a that good idea as it means almost every case now has
a branch for two entirely separate cases.  Wouldn't it be better to have
a separate helper for the looking at the current proces case?

Either way support for looking at the current thread should only be
merged together with an actual user for that.

