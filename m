Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0CJV2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:28:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab0CJV2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:28:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait_for_helper: SIGCHLD from user-space can lead to
	use-after-free
In-Reply-To: Oleg Nesterov's message of  Wednesday, 10 March 2010 22:19:23 +0100 <20100310211923.GA6485@redhat.com>
References: <20100310171634.GA1039@redhat.com>
	<20100310203209.54168BCCD@magilla.sf.frob.com>
	<20100310211923.GA6485@redhat.com>
Emacs: the definitive fritterware.
Message-Id: <20100310212710.D66A3A7C@magilla.sf.frob.com>
Date: Wed, 10 Mar 2010 13:27:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. kthreads run with all signal ignored, this is inherited from
> kthreadd() which does ignore_signal().

Ok.

> I don't think this can work. SIG_DFL for SIGCHLD is OK because it is
> sig_kernel_ignore(). But, say, SIGHUP and other signals still should
> be ignored, otherwise we have the same problems with the unwanted
> signal_pending() this patch tries to avoid.

Yes, I see.

> But even if we could do this,
> 
> > That should make it redundant in ____call_usermodehelper,
> > so it could be removed from there.
> 
> Please note that __call_usermodehelper() forks ____call_usermodehelper() too.

Ok.


Thanks,
Roland
