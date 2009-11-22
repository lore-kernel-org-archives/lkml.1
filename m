Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZKVHNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZKVHNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 02:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZKVHNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 02:13:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:58273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbZKVHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 02:13:29 -0500
Date: Sat, 21 Nov 2009 23:15:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091121231514.3012e679@infradead.org>
In-Reply-To: <20091122063926.GA18224@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091122063926.GA18224@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 07:39:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > ! Neither has any I/O apart from the pty conversation, so I'd
> > expect to ! see CPU usage at 100%. When I ran it, the CPU was
> > pretty well idle. ! After a fair bit of fiddling, it turned out
> > that both sides were ! taking about 8ms for their read() calls. At
> > that point it seemed ! pretty clear that this was a delay in the
> > kernel, not the code. ! 
> > [snip]
> > 
> > I can provide reasonably stripped down code which demonstrates the
> > problem.  It has been reproduced by one other person, though his
> > delay was about 2ms.


let me guess; you have HZ=250 and the other person has HZ=1000...
since this seems consistent with doing a 1 jiffy delay...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
