Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZASRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZASRIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZASRHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:07:51 -0500
Received: from cs-studio.ru ([195.178.208.66]:35934 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZASRHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:07:51 -0500
Date: Mon, 19 Jan 2009 20:07:49 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, dst@ioremap.net,
       David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20090119170749.GA24775@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <1231887933-17843-5-git-send-email-zbr@ioremap.net> <20090114215810.674569fc.akpm@linux-foundation.org> <20090118161041.40608174@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118161041.40608174@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Jan 18, 2009 at 04:10:41PM -0800, Arjan van de Ven (arjan@infradead.org) wrote:
> > 4: Your "dst thread pool"
> 
> from the context... I wouldn't be surprised if this can just use async
> function calls as well... it's simple enough on first sight.

No it can't. Since async function call requires additional allocation
which if failed fallbacks to the sync execution. This defeats the whole
purpose of the kernel thread. And this was already pointed to you Arjan,
but apparently you like to hide this.

Allocation in this path is very dangerous and even in case of atomic one
(which is used in the patch) this is a way heavy and unneded additional
overhead.

So neither DST nor pdflush should use such approach.

Arjan, please update your patch to met the feedback I gave in the
fsdevel mail list and do not allow to sneak the implementation if you do
not like the author :)

The only way to work with your async threads in the described cases is
to have a way to embed the needed event structure into the existing
objects like inode (which will be nacked by the fsdevel community for
reasone) or dst transaction (this may work). But existing size is
actually too big.

-- 
	Evgeniy Polyakov
