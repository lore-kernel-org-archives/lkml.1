Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbXIRQP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbXIRQP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXIRQPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:15:15 -0400
Received: from pat.uio.no ([129.240.10.15]:54672 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbXIRQPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:15:13 -0400
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <20070918151957.GA18476@fieldses.org>
References: <46EE3724.80200@openvz.org>
	 <1190037331.6700.14.camel@heimdal.trondhjem.org>
	 <46EE8C52.80503@openvz.org>
	 <1190044850.6700.81.camel@heimdal.trondhjem.org>
	 <46EF7136.7080308@openvz.org>  <20070918151957.GA18476@fieldses.org>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 12:14:55 -0400
Message-Id: <1190132095.6656.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.080)
X-UiO-Scanned: C53CE95E4AFC0E0224E165E54E18429B5099402A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 216 total 3953770 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 11:19 -0400, J. Bruce Fields wrote:
> Maybe this should be documented, e.g. in fcntl(2).  I'm not sure exactly
> what we'd say--we probably don't want to commit to the current behavior.
> Maybe something like "behavior is undefined when setting or clearing
> mandatory locking on a file while it is locked".

The behaviour is pretty much undefined if you set/clear mandatory
locking on the file while some application has it open. It is hard to
see how you can avoid that unless you exclude simultaneous chmod,
read(), write(), and fcntl(SETLK) operations.

Note also that strictly speaking, we're not even compliant with the
System V behaviour on read() and write(). See:

  http://www.unix.org.ua/orelly/networking_2ndEd/nfs/ch11_01.htm
and
  http://docs.sun.com/app/docs/doc/801-6736/6i13fom0a?l=en&a=view&q=mandatory+lock

According to these docs, we should be wrapping each and every read() and
write() syscall with a mandatory lock. The fact that we're not, and yet
still not seeing any complaints just goes to show how few people are
actually using and relying on this...

  Trond

