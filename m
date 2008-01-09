Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYAISSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYAISSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYAISSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:18:47 -0500
Received: from c60.cesmail.net ([216.154.195.49]:43451 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbYAISSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:18:46 -0500
Subject: Re: Replacement for page fault notifiers?
From: Pavel Roskin <proski@gnu.org>
To: benh@kernel.crashing.org
Cc: Dave Airlie <airlied@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <1199838407.6734.83.camel@pasglop>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 13:18:44 -0500
Message-Id: <1199902724.8050.11.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 11:26 +1100, Benjamin Herrenschmidt wrote:
> > Christoph,
> > 
> > it is generic code, it works by patching the module you load and is in
> > no way nvidia specific, I think we should revert your chance
> > as the notifiers have a valid user and one it has been planned to upstream..
> 
> Agreed, it looks like a sane enough user of page fault notifiers, it's
> going to be upstream, and it's useful to fight evil binary drivers so
> that sounds like a good justification to bring those back in :-)

The fault notifiers are used in a special version of MadWifi (Atheros
wireless driver with some non-free parts) to figure out which registers
are being accessed.  The tracing capability has been essential for the
development of the free replacement, ath5k.

Considering that ath5k is being developed in the kernel tree, whereas
madwifi-trace needs 2.6.23, one needs different kernels for tracing and
development.  Lifting this requirement would be a time saver for the the
developers of ath5k.  And once 2.6.24 is released, ath5k developers will
be in the position to ask users to downgrade their kernels to get traces
for their cards.  That's something I'd like to avoid.

I looked at ways to implement the page fault handler using kprobes, but
I could not find a simple solution.  The problem is that kprobes uses
the fault notifier for its own needs.  I'm still hopeful that somebody
with a better understanding of kprobes will be able to implement fault
notification without patching the kernel.  But if no such solution is
found, I would also support reverting the patch that removed fault
notifiers on i386.

-- 
Regards,
Pavel Roskin
