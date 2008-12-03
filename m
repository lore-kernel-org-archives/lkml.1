Return-Path: <linux-kernel-owner+w=401wt.eu-S1762468AbYLCUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468AbYLCUff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbYLCULi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:11:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbYLCULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:11:35 -0500
Date: Wed, 3 Dec 2008 14:13:20 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
Message-ID: <20081203201320.GA17785@hallyn.com>
Reply-To: "In-Reply-To:20081203123021.GA30035"@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Hellwig (hch@infradead.org):
> On Tue, Dec 02, 2008 at 04:47:56PM -0500, Mimi Zohar wrote:
> > +/*
> > + * Integrity API calls:
> > + *
> > + * @collect_measurement:
> > + *	Collect template specific measurement data.
> > + *	@data contains template specific data used for collecting the
> > + *	measurement.
> > + * 	Return 0 if operation was successful.
> > + *
> > + * @appraise_measurement:
> > + *	Appraise the integrity of the template specific measurement data.
> > + *	@data contains template specific data used for appraising the
> > + *	measurement.
> > + * 	Return 0 if operation was successful.
> > + *
> > + * @store_measurement:
> > + *	Store the template specific data.
> > + *	@data contains template specific data used for storing the
> > + *	measurement.
> > + *
> > + * @store_template:
> > + *	Store the entry containing the template specific data.
> > + *	@data contains template name, data length, and data.
> > + *
> > + * @must_measure:
> > + *	Measurement decision based on an integrity policy.
> > + *	@data contains template specific data used for making policy
> > + * 	decision.
> > + * 	Return 0 if operation was successful.

This comment isn't right - return 0 if a measurement must be
taken, no?

> > + *
> > + * @display_template:
> > + *	Display template specific data.
> > + *
> > + */
> 
> Can you explain what all this template stuff is about?  The only method
> of these ever called is display_template,

I'm not sure what you mean here - must_measure for instance is used (in
patch 3) in the integrity hooks (i.e. file_mmap) to decide whether or not 
the object (action target) must be measured.

> and that seems to be better
> implented directly as a securityfs file, without the indirection.

That comment doesn't make sense to me (unless you're saying to punt
on the generic integrity infrastructure and hook all of the IMA
code straight into the kernel) so I suspect I'm misreading
something.

-serge
