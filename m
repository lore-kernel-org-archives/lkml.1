Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZBSUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZBSUMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZBSUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:12:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753524AbZBSUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:12:05 -0500
Date: Thu, 19 Feb 2009 15:12:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-kernel@vger.kernel.org>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
In-Reply-To: <20090218155817.GC23989@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0902191505050.7953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009, Ingo Molnar wrote:

> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > I have no idea if this will make any difference for the 
> > problem you're seeing, but it has been submitted and it's 
> > worth trying out.  If the problem still occurs, I'll write a 
> > diagnostic patch to add log messages giving the destiny of 
> > each request in scsi_io_completion().
> 
> OK, i've undone the reverts and have applied your fix - it will 
> take a few hours to see whether the hang still occurs.

Any definitive results yet?

It turns out that the patch I posted earlier is not quite correct; the
"__scsi_release_buffers(cmd, 0);" line in scsi_end_request() was added
after the patch was first written and then got lost during rebasing.

If this really does fix your problem and nobody has any other
objections to it, I'll submit a revised version with the missing line
added back in.

You might also want to try testing separately this patch from James:

	http://marc.info/?l=linux-scsi&m=123506890608499&w=2

It may solve the same problem, though in a different way.

Alan Stern

