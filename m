Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbZA1Roo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbZA1Roo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZA1RoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:44:24 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56311 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbZA1RoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:44:23 -0500
Subject: RE: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: Christoph Hellwig <hch@infradead.org>,
       Krishna Gudipati <kgudipat@Brocade.COM>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com>
References: <200901271854.n0RIs73a026759@swe37.brocade.com>
	 <20090127221618.GA26480@infradead.org>
	 <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 17:44:22 +0000
Message-Id: <1233164662.3236.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 15:07 -0800, Jing Huang wrote:
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Tuesday, January 27, 2009 2:16 PM
> > To: Jing Huang
> > Cc: James.Bottomley@HansenPartnership.com; Krishna Gudipati; linux-
> > kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Ramkumar Vadivelu;
> > Vinodh Ravindran
> > Subject: Re: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
> > 
> > On Tue, Jan 27, 2009 at 10:54:07AM -0800, Jing Huang wrote:
> > > +/**
> > > + * Generic HAL callback element.
> > > + */
> > > +struct bfa_cb_qe_s {
> > > +	struct bfa_q_s         qe;
> > > +	bfa_cb_cbfn_t  cbfn;
> > > +	bfa_boolean_t   once;
> > > +	u32		rsvd;
> > > +	void           *cbarg;
> > > +};
> > > +
> > > +#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {
> \
> > > +	(__hcb_qe)->cbfn  = (__cbfn);
> \
> > > +	(__hcb_qe)->cbarg = (__cbarg);
> \
> > > +	bfa_q_enq(&(__bfa)->comp_q, (__hcb_qe));
> \
> > > +} while (0)
> > 
> > Please stop here, weird HALs and own list management routines are not
> > things we put into the tree.  (except for gregs junk subdirectory..)
> > 
> > Please rewrite this into a proper Linux driver.
> 
> 
> Thanks Christoph for the code review,
> 
> I will clean up all the HAL references and also replace our own list
> management code with standard linux implementation.

This might take a while.  I can offer to put this driver in the staging
tree while you work on it if that would be helpful?

The way the staging tree works is that drivers are held in a separate
area (drivers/staging) in the linux kernel while they're being worked
on.  The driver can be installed by users while it's in the staging tree
(so made use of) but it will taint the kernel with a warning that it's
not of linux kernel quality yet.  Once we get an acceptable driver in
drivers/staging, I'll move it across to drivers/scsi and remove the
taint.

James



