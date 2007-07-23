Return-Path: <linux-kernel-owner+w=401wt.eu-S936253AbXGWVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936253AbXGWVCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbXGWVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:01:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:24792 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761402AbXGWVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aV7lE0ckMNSw26GBPT/b1SQg1Vi1v7pdIZnTBTLU1SAt2Fe35lqbNcKF2bFsBX1Fix9k3TdCTkmewPPADApXmT/k9PZnlN3e5Ni8Fmmxl41taq5kjs98loJrebkniUnnr8M3hhOorNcUbVXvV7OTi/SRHgrms4lU58WxekTk9ZY=
Date: Tue, 24 Jul 2007 01:01:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-ID: <20070723210153.GA5753@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru> <20070723132431.42afbae8.akpm@linux-foundation.org> <20070723204045.GD5755@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723204045.GD5755@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 12:40:45AM +0400, Alexey Dobriyan wrote:
> > I had more complete info: http://article.gmane.org/gmane.linux.network/66966
> > 
> > You're using DEBUG_PAGEALLOC, but I was not, so I think we can rule that out.
> > 
> > I haven't worked out where that kmap_atomic() call is coming from yet. 
> > Both traces point up into the page allocator, but I _think_ that's stack
> > gunk.
> 
> Ahh, you suspect networking.
> 
> Here, setup is 2 cheap-ass 100Mb realtek 8139 NICs, one to campus network
> receiving ~20 junk packets per second, one gathering netconsole output
> and ssh to it, no conntracks and fancy stuff.
> 
> [reboots with cables physically unplugged]

OK, I run gdb recompile, cat(1) every file in /usr/portage (shitload of
small files) with both cables unplugged. It all went fine for ~5 minutes
after that it crashed exactly same way after 10 secs after plugging one
of them.

