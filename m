Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYGPO7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYGPO7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYGPO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:59:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbYGPO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:59:21 -0400
Date: Wed, 16 Jul 2008 16:59:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Message-ID: <20080716145900.GA31258@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain> <20080716141805.GB22631@elte.hu> <20080716144106.GD25255@parisc-linux.org> <20080716144602.GB4369@elte.hu> <20080716145703.GF25255@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716145703.GF25255@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jul 16, 2008 at 04:46:02PM +0200, Ingo Molnar wrote:
> > yeah, that's OK - but why is scsi.h #ifdef-ed? For example we can 
> > include blkdev.h without #ifdef CONFIG_BLOCK.
> 
> Sure.  The important bit comes when deciding which bits need to be 
> available when CONFIG_BLOCK isn't set.  Obviously, there is no SCSI 
> without block (while sg is a character device, not a block device, it 
> depends on the block infrastructure to the extent that you couldn't 
> use it without CONFIG_BLOCK).
> 
> While it's not impossible that someone could want the SCSI protocol 
> and opcodes, status codes, etc. for a different character device, that 
> seems unlikely.  The four opcodes defined in the header seem to be 
> pretty SCSI-specific and not useful to use on non-scsi devices. 
> SCSI_IOCTL_GET_PCI looks like it might possibly be useful on more than 
> just SCSI, but we have better ways (ie sysfs) of determining the same 
> information in a more general way.
> 
> So I think it's fair to put an #ifdef CONFIG_BLOCK right after the 
> _SCSI_SCSI_H define and close it right at the end of the file.

yes, that's what blkdev.h does, and that's what i was suggesting we do, 
instead of #ifdef-ing around scsi.h use in fs/compat_ioctl.c.

	Ingo
