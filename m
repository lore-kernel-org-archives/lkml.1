Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXLSBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXLSBO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbXLSBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:14:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51190 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbXLSBOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:14:49 -0500
Date: Tue, 18 Dec 2007 20:14:36 -0500
Message-Id: <200712190114.lBJ1Ean2023273@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] unionfs: restructure unionfs_setattr 
In-reply-to: Your message of "Wed, 19 Dec 2007 00:53:12 GMT."
             <Pine.LNX.4.64.0712190030390.5639@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0712190030390.5639@blonde.wat.veritas.com>, Hugh Dickins writes:
> On Tue, 18 Dec 2007, Erez Zadok wrote:
> > In message <Pine.LNX.4.64.0712182213300.28390@blonde.wat.veritas.com>, Hugh Dickins writes:
> > > In order to fix unionfs truncation, we need to move the lower notify_change
> > > out of the loop in unionfs_setattr.  But when I came to do that, I couldn't
> > [...]
> > 
> > Hugh, I want to understand how patches 3/4 and 4/4 are related.  In patch 3
> > you say "in order to fix truncation" but you mention a truncation problem
> > only in patch 4; is there a patch ordering problem, or they're both related
> > to the same issue (with 3/4 being a code cleanup, and 4/4 actually fixing
> > the problem)?
> 
> I needed to move that notify_change out of the loop, to fix the truncation
> problem, but had great difficulty understanding the loop.  So, just as you
> say, made the code cleanup first in 3/4, then fixed the problem in 4/4.
> 
> But that cleanup does need your review and testing.

A quick look at your setattr patches seems very promising.  And I've further
realized more cleanup is possible: because we call revalidate_chain at the
opening to ->setattr, we're guaranteed to have a valid lower dentry, so for
example we can remove the else case for "if (lower_dentry)".

I'll be testing this and your other patches, plus look into the locking
issues you brought up.

Thanks,
Erez.
