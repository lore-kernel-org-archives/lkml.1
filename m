Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbXFYVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbXFYVnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXFYVm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:42:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42456 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbXFYVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:42:57 -0400
Date: Mon, 25 Jun 2007 23:42:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, linux-kernel@vger.kernel.org
Subject: Re: synchronize_qrcu_timeout()
Message-ID: <20070625214246.GC2051@elf.ucw.cz>
References: <20070625104332.GA147@tv-sign.ru> <20070625145851.GB12976@linux.vnet.ibm.com> <20070625152011.GA160@tv-sign.ru> <20070625154957.GA197@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625154957.GA197@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-25 19:49:57, Oleg Nesterov wrote:
> On 06/25, Oleg Nesterov wrote:
> >
> > On 06/25, Paul E. McKenney wrote:
> > >
> > > On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
> > > > 
> > > > Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	
> > > 
> > > Interesting...  So the thought is to have a synchronize_srcu_timeout()
> > > or something similar that waited for a grace period to elapse or for
> > > a timeout to expire, whichever comes first?  It should not be too hard
> > > to arrange something, if needed.
> > 
> > Yes. As for qrcu (see http://marc.info/?t=116484476500001), I think it is easy.
> > First, we add "int interrupted" into struct qrcu_struct, then something like this
> 
> Even simpler, we don't need ->interrupted.
> 
> 	long synchronize_qrcu_timeout(struct qrcu_struct *qp, long tout)
> 	{
> 		int idx, prv;

Could we get less encrypted variable names? tout? Yes, I can decipher it.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
