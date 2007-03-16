Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXCPOWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXCPOWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXCPOWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:22:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbXCPOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:22:28 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070316150705.0b2fbeb0@lxorguk.ukuu.org.uk> 
References: <20070316150705.0b2fbeb0@lxorguk.ukuu.org.uk>  <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com> <20070316125026.3740.56876.stgit@warthog.cambridge.redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 3/5] AF_RXRPC: Make it possible to merely try to cancel timers and delayed work [try #2] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 16 Mar 2007 14:22:09 +0000
Message-ID: <25539.1174054929@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +static inline int try_to_cancel_delayed_work(struct delayed_work *work)
> > +{
> > +	int ret;
> 
> This expands to a fair bit of code and IMHO isn't an inline candidate.

Then why is cancel_delayed_work() inline?  It's very similar in terms of
expansion.

And it's not a fair bit of code.  try_to_cancel_delayed_work() is out of line,
and work_release() is just clear_bit() in disguise.

David
