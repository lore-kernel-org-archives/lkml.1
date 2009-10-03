Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZJCSgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZJCSgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZJCSgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:36:04 -0400
Received: from bu3sch.de ([62.75.166.246]:32861 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbZJCSgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:36:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [PATCH RFC] isdn/capi: fix up CAPI subsystem workaround locking a bit
Date: Sat, 3 Oct 2009 20:35:19 +0200
User-Agent: KMail/1.9.9
Cc: i4ldeveloper@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       Armin Schindler <armin@melware.de>, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091003120657.2228911186C@xenon.ts.pxnet.com> <200910032026.24451.mb@bu3sch.de>
In-Reply-To: <200910032026.24451.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910032035.21884.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 October 2009 20:26:22 Michael Buesch wrote:
> On Saturday 03 October 2009 14:06:57 Tilman Schmidt wrote:
> > Move calls to handle_minor_send() and handle_minor_recv() out of
> > the sections locked by workaround_lock.
> > - handle_minor_send() may call another CAPI function via the card
> >   driver, deadlocking by trying to take workaround_lock again.
> > - handle_minor_recv() calls the receive_buf method of the active
> >   line discipline which may sleep.
> 
> I remember that handle_minor_send() and/or handle_minor_recv() showed up
> in the crash backtraces. So if you move them out of the critical
> section, you can as well remove the lock completely.
> 

here's my original mail:
http://lkml.indiana.edu/hypermail/linux/kernel/0605.0/0455.html

Note the patch in that mail does _not_ fix the issue, as it turned out later.
Then I did the workaround-lock patch, which _did_ fix it.

But in that mail you can see the original crash backtraces, which might be
useful for finding out what _really_ happened.

-- 
Greetings, Michael.
