Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYDISlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYDISlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDISlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:41:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbYDISlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:41:04 -0400
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
From: David Woodhouse <dwmw2@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080409162206.GA764@tv-sign.ru>
References: <20080329001230.D013726FA1D@magilla.localdomain>
	 <20080329001341.7F93826FA1D@magilla.localdomain>
	 <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
	 <20080408113519.GA227@tv-sign.ru>
	 <1207739787.27048.57.camel@shinybook.infradead.org>
	 <20080409113939.GA99@tv-sign.ru>
	 <1207757653.27048.77.camel@shinybook.infradead.org>
	 <20080409162206.GA764@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 19:40:33 +0100
Message-Id: <1207766433.27048.86.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 20:22 +0400, Oleg Nesterov wrote:
> On 04/09, David Woodhouse wrote:
> >
> > One of the supposed advantages of TIF_RESTORE_SIGMASK in the first
> > place, iirc, was that it allowed us to return a result code other than
> > -EINTR as _well_ as restoring the signal mask.
> 
> Agreed, good point. ERESTART_ is not that flexible.
> 
> Somehow I assumed we will never need something "special" here, this is
> not very clever.

Well, it's not clear that we _will_ need it to be so special. You could
perhaps argue that it's overengineering. It's just that at the time I
did it, I _thought_ I'd need it for ppoll().

It's only in later optimisations that I realised we only ever really
needed to use TIF_RESTORE_SIGMASK in the case where ppoll() or pselect()
was interrupted.

-- 
dwmw2

