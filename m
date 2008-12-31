Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYLaAFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYLaAFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYLaAF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:05:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYLaAF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:05:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, ebiederm@xmission.com,
       bastian@waldi.eu.org, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/7][v4] Protect cinit from blocked fatal signals
In-Reply-To: Oleg Nesterov's message of  Wednesday, 24 December 2008 17:09:31 +0100 <20081224160931.GC11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com>
	<20081224115229.GE8020@us.ibm.com>
	<20081224160931.GC11593@redhat.com>
X-Zippy-Says: I'm wearing PAMPERS!!
Message-Id: <20081231000445.CEBC8FC278@magilla.sf.frob.com>
Date: Tue, 30 Dec 2008 16:04:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * If @signal refers to a container-init and @signr is neither SIGKILL nor
> > + * SIGSTOP, it was queued because it was blocked when it was posted.
> 
> This is not right too. It is possible that init had a handler when
> the signal was sent, and the handler was set to SIG_DFL before the
> signal was dequeued.

do_sigaction's sig_handler_ignored() should exclude that.


Thanks,
Roland
