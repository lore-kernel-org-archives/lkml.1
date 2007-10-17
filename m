Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXJQTZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXJQTZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXJQTZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:25:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17504 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXJQTZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:25:10 -0400
Date: Wed, 17 Oct 2007 21:25:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017192504.GY15552@kernel.dk>
References: <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190422.GA12711@elte.hu> <20071017190821.GX15552@kernel.dk> <20071017191456.GA14916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017191456.GA14916@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 17 2007, Ingo Molnar wrote:
> > > 
> > > btw., i get the following build warning:
> > > 
> > > drivers/scsi/scsi_lib.c: In function 'scsi_free_sgtable':
> > > drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
> > > drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
> > > drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
> > > drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
> > > drivers/scsi/scsi_lib.c: In function 'scsi_alloc_sgtable':
> > > drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
> > > drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
> > > 
> > > not sure it matters.
> > 
> > Hmm, I don't see them here (gcc 4.2.1). Must be the BUG(), does it go 
> > away if you add a index = -1 in the default: case? Just to be 
> > absolutely sure...
> 
> well if i initialize the variable then of course the warning goes away
> :)

Just making 100% sure that was the missing place, I try not to take
anything for granted with crazy bugs like this :-)
> 
> NOTE: i get the same warning even without the BUG_ON() patch, and 
> without your other fix patch as well. I'm using gcc 4.2.2. (Do you get 
> the warning if you pick up the config i sent you earlier today?)

Let me check... Yep, I do!

-- 
Jens Axboe

