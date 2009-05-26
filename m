Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZEZVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZEZVGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZEZVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:06:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZEZVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:06:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 20:55:02 +0200 <20090525185502.GA20781@redhat.com>
References: <20090525185502.GA20781@redhat.com>
Emacs: freely redistributable; void where prohibited by law.
Message-Id: <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 14:05:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

Yes, all cases setting .si_pid should set it using the pid_ns of the
recipient.  Numerous other cases look wrong too, though maybe Sukadev has
outstanding patches for those already?  (It's been a while since we went
around on this, and I am fuzzy on some of the details.)  ptrace_notify,
ptrace_signal, sys_kill, do_tkill all look wrong to me.  (Only sys_kill
needs to solve the multiple-recipients problem.)


Thanks,
Roland
