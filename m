Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZFLEBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZFLEBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZFLEA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:00:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZFLEA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:00:57 -0400
Date: Fri, 12 Jun 2009 06:58:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davdel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 0/2] irqfd: use POLLHUP notification for close()
Message-ID: <20090612035425.GA4773@redhat.com>
References: <20090604124047.10544.38861.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604124047.10544.38861.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:48:02AM -0400, Gregory Haskins wrote:
> (Applies to kvm.git/master:25deed73)
> 
> Please see the header for 2/2 for a description.  This patch series has been
> fully tested and appears to be working correctly.
> 
> [Review notes:
>       *) Paul has looked at the SRCU design and, to my knowledge, didn't find
>          any holes.
>       *) Michael, Avi, and myself agree that while the removal of the DEASSIGN
>          vector is not desirable, the fix on close() is more important in
>          the short-term.  We can always add DEASSIGN support again in the
> 	 future with a CAP bit.
> ]

So, I've been thinking about this, and this approach has another
problem: it depends on pollhup on close which is AFAIK an
eventfd-specific feature. This will prevent us from supporting polling
other useful file types, such as sockets and pipes, down the road, with
this interface.

And there's DEASSIGN issue which is needed for migration and MSI vector
remapping.

I didn't realise these implications when I suggested deassign on close.
To me, it now looks like we are better off reverting this patch.
We can later add 'deassign on close' support with CAP bit after all :)

Avi, Gregory, what's your take?

-- 
MST
