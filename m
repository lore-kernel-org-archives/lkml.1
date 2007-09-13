Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbXIMVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbXIMVT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXIMVTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:19:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbXIMVTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:19:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0709131304510.16478@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0709131304510.16478@woody.linux-foundation.org> <1577.1189713412@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 13 Sep 2007 22:19:01 +0100
Message-ID: <1839.1189718341@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That "current_cred" thing is really too ugly to live.

Agreed.

> Why is it trying to make it look like a variable?

Like 'current' for instance?

	static __always_inline struct task_struct *get_current(void)
	{
		return x86_read_percpu(current_task);
	}

	#define current get_current()

> That will just confuse people, and/or make them think it's a cheap thing
> rather than some complex function call.

Yes, I know it's silly.

One thing I was trying to do was make it possible to change how the cred
structure was accessed without having to keep going back and change a whole
load of stuff each time.

> IOW, this patch should be taken out and shot, for apparently actively 
> trying to obfuscate what the heck is going on.

It's a 'test' patch, as you'll note from the subject, and not particularly
near completion.  I'm interested in garnering useful comments, particularly on
the points of concern that I raised.

I have no intention of asking you to merge it as it stands - I was hoping that
would be clear.

David
