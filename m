Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZBRTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZBRTRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZBRTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:17:05 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51426 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZBRTRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:17:02 -0500
Date: Wed, 18 Feb 2009 11:16:43 -0800
From: Mike Anderson <andmike@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Message-ID: <20090218191643.GA16347@linux.vnet.ibm.com>
References: <20090215115823.GB19464@elte.hu> <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org> <20090218155817.GC23989@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218155817.GC23989@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
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
> 

I know already started your testing, but..

I find it informative to set my scsi logging to the value below to display
non-zero IO status on commands. The overhead impact is low for good
completions.

sysctl -w dev.scsi.logging_level=4100

Note: This does not provide the exact policy that scsi_io_completion will
take on the IO, but it provides the input to scsi_io_completion which
should help.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
