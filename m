Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbXGEIYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbXGEIYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXGEIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:24:25 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:48131 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbXGEIYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:24:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 10:24:22 +0200
User-Agent: KMail/1.9.7
Cc: paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707051024.23528.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Miklos Szeredi:
> > > > I have discussed the benefits elsewhere.  As for the deadlocks -- do 
> > > > you still observe them if you use the version of the freezer which 
> > > > doesn't freeze kernel threads?
> > > 
> > > In general the only way to guarantee there are no deadlocks is to
> > > construct the graph of dependencies between tasks.  Those dependencies
> > > are not in practice observable from outside the tasks, so it is
> > > virtually impossible to construct the graph.
> > 
> > In which way can user space tasks depend on each other in a way that
> > allows a them members of that cycle to be in uninterruptible sleep?
> 
>  - process A calls rename() on a fuse fs
>  - process B, the fuse server, starts to process the rename request
>  - process B is frozen before it can reply
> 
> Now process A is unfreezable.  We cannot make rename() restartable,
> hence it cannot be interruptible.

Then this is a problem specific to fuse. You should teach fuse to block
suspension while such operations are being performed.

	Regards
		Oliver

