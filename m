Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbXGKMf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbXGKMf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbXGKMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:35:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:56032 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXGKMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:35:50 -0400
Date: Wed, 11 Jul 2007 14:36:03 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
Message-ID: <20070711143603.1f474b39@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <469464EC.7030502@gmail.com>
References: <Pine.LNX.4.44L0.0707101459580.2556-100000@iolanthe.rowland.org>
	<469464EC.7030502@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 14:04:44 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Thanks for enlightening me.  Probably what can be done is blocking
> regular file sysfs nodes automatically and make it optional (optionally
> enable or disable) for bin attrs.

Perhaps all files should block by default, but have a knob to disable
blocking for special cases (or an attribute flag like ATTR_NOFREEZE?)

> >>> Using a freezable workqueue for the callbacks would also localize the 
> >>> suspend handling.
> >> But the freezable workqueue thing isn't really necessary if any of the
> >> discussed solutions is implemented, right?
> > 
> > It isn't necessary if the callbacks aren't needed (i.e., if we give
> > methods a way to unregister their attribute directly).  But if we do
> > keep the callbacks, then for safety's sake their workqueue should be
> > freezable.

I agree.

> I see.  Let's see how the direct suicide thing works out.

If it can be done nicely, I'd prefer it over the workqueue solution -
but not if we end up with hard-to-understand code.
