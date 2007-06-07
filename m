Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbXFGRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbXFGRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbXFGRb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:31:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53909 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXFGRb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:31:28 -0400
Date: Thu, 7 Jun 2007 13:30:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       akpm@linux-foundation.org, david@dgreaves.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA commands
Message-ID: <20070607173027.GC11882@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org> <20070606160511.GA23143@havoc.gtf.org> <46683E4D.9060801@redhat.com> <20070607172507.GB11882@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607172507.GB11882@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:25:07PM -0400, Jeff Garzik wrote:
> On Thu, Jun 07, 2007 at 01:20:13PM -0400, Chuck Ebbert wrote:
> > On 06/06/2007 12:05 PM, Jeff Garzik wrote:
> > > FYI to all -- 
> > > 
> > > As a reminder. the Promise hardware programs registers when it receives
> > > a SET FEATURES - XFER MODE.
> > > 
> > > If data transfer is occurring on OTHER ports at the time this is issued,
> > > then data corruption is guaranteed to occur.  Polling will not fix this
> > > problem -- all ports need to be inactive, when a SET FEATURES - XFER
> > > MODE command is issued for any port.
> 
> > So is this patch OK but yet more work needs to be done, or does
> > this patch cause new problems?
> 
> Causes no /new/ problems...  :)  The existing problem described above
> remains.

Just to expand...  this problem doesn't really affect a lot of users in
the majority case, since we do speed tuning before data transfer starts.

The main problem that remains is the rare (but no less important) case
where libata-EH will tune speed during operation in respond to certain
classes of errors.

	Jeff



