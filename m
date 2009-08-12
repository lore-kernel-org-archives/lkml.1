Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZHLPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZHLPAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZHLPAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:00:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35218 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbZHLPAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:00:38 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908121034150.2955-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121034150.2955-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 10:00:34 -0500
Message-Id: <1250089234.4000.22.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 10:54 -0400, Alan Stern wrote:
> > > + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> > > + * They don't do the same thing (they cancel the work instead of waiting
> > > + * for it to complete), but in most cases they will suffice.
> > > + */
> > 
> > And this is wrong advice.  If you've violated the entangled deadlock
> > rules, the cancel functions will deadlock on you as well if the work is
> > still pending.
> 
> No they won't.  They will remove the work item from the workqueue right
> away, without blocking, assuming it hasn't started yet (i.e., is still 
> pending).  This is a large part of their raison d'etre.

Yes, they will ... you advised the _sync function which waits if the
work is in progress and hence induces the entanglement.  You can get
away with this if you don't use _sync (but then you won't know when the
queue is safely not touching any module code before removal).

James


