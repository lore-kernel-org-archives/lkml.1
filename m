Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbZAGUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbZAGUyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZAGUxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:53:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbZAGUxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:53:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: Ingo Molnar's message of  Wednesday, 7 January 2009 13:34:57 +0100 <20090107123457.GB16268@elte.hu>
References: <49639EB8.40204@redhat.com>
	<4963ABF0.6070400@redhat.com>
	<20090107123457.GB16268@elte.hu>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
Date: Wed,  7 Jan 2009 12:53:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New syscall should have gone to linux-api, I think.

Do we really need another one for this?  How about using signalfd plus
setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
SIGCHLD?  It's slightly more magical for the userland process to know to do
that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
really have to add, maybe better.


Thanks,
Roland
