Return-Path: <linux-kernel-owner+w=401wt.eu-S1030752AbXDVT15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752AbXDVT15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030727AbXDVT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:27:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37443 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811AbXDVT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:27:05 -0400
Date: Sun, 22 Apr 2007 20:26:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd_blkdevs: Convert to use the kthread API
Message-ID: <20070422192646.GA15668@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769657692046-git-send-email-ebiederm@xmission.com> <20070422122453.GE20763@infradead.org> <1177248180.2755.12.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177248180.2755.12.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 02:23:00PM +0100, David Woodhouse wrote:
> On Sun, 2007-04-22 at 13:24 +0100, Christoph Hellwig wrote:
> > This is the full conversion I sent to Dave in April 2006, but never
> > got any feedback to:
> 
> Sorry about that; I need prodding sometimes. I'll provide some now... 
> 
> Can you show me why the thread won't now miss a wakeup if it goes to
> sleep just as a new request is added to its queue?

Exactly the same thing that happened before.  If you look at
wake_up_process it's just a tiny wrapper around try_to_wake_up.

And wake_up expands to __wake_up expaneds to __wake_up_common
which just walks the list of threads attached to the waitqueue
and then calls curr->func, which expands to try_to_wake_up.

So when your thread still is in running state nothing changes.
If your thread is not in running state it'll get woken by both
variants.

