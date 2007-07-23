Return-Path: <linux-kernel-owner+w=401wt.eu-S936346AbXGWVL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936346AbXGWVL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759665AbXGWVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:11:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbXGWVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:11:45 -0400
Date: Mon, 23 Jul 2007 14:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-Id: <20070723141137.171e4ac1.akpm@linux-foundation.org>
In-Reply-To: <20070723210153.GA5753@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<20070723183839.GA5874@martell.zuzino.mipt.ru>
	<20070723190152.GA5755@martell.zuzino.mipt.ru>
	<20070723132431.42afbae8.akpm@linux-foundation.org>
	<20070723204045.GD5755@martell.zuzino.mipt.ru>
	<20070723210153.GA5753@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 01:01:53 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Jul 24, 2007 at 12:40:45AM +0400, Alexey Dobriyan wrote:
> > > I had more complete info: http://article.gmane.org/gmane.linux.network/66966
> > > 
> > > You're using DEBUG_PAGEALLOC, but I was not, so I think we can rule that out.
> > > 
> > > I haven't worked out where that kmap_atomic() call is coming from yet. 
> > > Both traces point up into the page allocator, but I _think_ that's stack
> > > gunk.
> > 
> > Ahh, you suspect networking.
> > 
> > Here, setup is 2 cheap-ass 100Mb realtek 8139 NICs, one to campus network
> > receiving ~20 junk packets per second, one gathering netconsole output
> > and ssh to it, no conntracks and fancy stuff.
> > 
> > [reboots with cables physically unplugged]
> 
> OK, I run gdb recompile, cat(1) every file in /usr/portage (shitload of
> small files) with both cables unplugged. It all went fine for ~5 minutes
> after that it crashed exactly same way after 10 secs after plugging one
> of them.

It'd be nice to get a clean trace.  Are you able to obtain the full
trace with CONFIG_FRAME_POINTER=y?
