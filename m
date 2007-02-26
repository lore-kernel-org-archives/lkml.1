Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbXBZLts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbXBZLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXBZLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:49:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXBZLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:49:47 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45E09989.5070604@google.com> 
References: <45E09989.5070604@google.com>  <45DFB1C7.1030205@google.com> <45D5B2E3.3030607@hitachi.com> <17044.1172311335@redhat.com> 
To: Markus Gutschke <markus@google.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Feb 2007 11:49:14 +0000
Message-ID: <2910.1172490554@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Gutschke <markus@google.com> wrote:

> > How does it work when you can't actually get back to userspace to have
> > userspace do the coredump?  You still have to handle the userspace
> > equivalents of double/triple faults.
> 
> My experience shows that there are only very rare occurrences of situations
> where you cannot get back into userspace to do the coredump, and the
> coredumper tries very hard never to cause additional faults.

So what?  If they can occur, you have to handle them.

> While I am sure you could construct scenarios where this would happen,
> realistically the only one I have run into were stack overflows, and they can
> be handled by carefully setting up an alternate stack for signal handlers --
> just make sure the entire stack is already dirtied before you run out of
> memory (or, turn of overcommitting).

Duff SIGSEGV or SIGBUS signal handlers are just as realistic.  All that takes
is for someone to make a programming error.  Remember: error paths are the
least frequently tested.

And any time you say "by carefully setting up" you can guarantee someone's
going to do it wrong.

David
