Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYLDNKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYLDNKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYLDNJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:09:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYLDNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:09:50 -0500
Date: Thu, 4 Dec 2008 08:09:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
Message-ID: <20081204130949.GA18196@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com> <20081203123021.GA30035@infradead.org> <1228328323.2821.30.camel@localhost.localdomain> <20081203182300.GA31203@infradead.org> <1228342655.2821.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228342655.2821.64.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 05:17:35PM -0500, Mimi Zohar wrote:
> > I have a bit of a problem parsing the above, and it certainly doesn't
> > look like a justification for keeping all that unused code around.
> 
> The purpose of LIM is to provide an integrity infrastructure to support 
> different types of integrity data.  IMA implements both the LIM
> API for it's own internal use, and exports it for others to call.
> 
> As Dave Safford pointed out in http://lkml.org/lkml/2008/11/17/362,
> there are other projects that want to add differently structured
> measurements to the TPM measurement list.  The template abstraction is
> critical to allowing these differently formatted messages to be added to
> the list.

I think we're talking past each other.

In integrity.h there are two operation vectors defines:

 - struct integrity_operations delcares the operations called from the
   VFS.  This one is actually used.  While I don't agree to Dave's
   argument, because we don't put bloat in just because people might
   eventually some day use it when they are in the right mood and the
   sun shines, thisn't isn't the one I'm talking about in this thread.
 - struct template_operations on the others is not only really badly
   named for appearing in a global header but also not used in a
   meaningfull way.  There is one single instace of it,
   ima_template_ops, and while there are five helpers added in the
   second patch that use it (integrity_collect_measurement,
   integrity_appraise_measurement, integrity_store_measurement,
   integrity_store_template, integrity_must_measure) none of them
   is used at all during the patch series.  There are two direct
   uses of these template added in the third path, to implement the
   show operations for the "binary_runtime_measurements" and
   "ascii_runtime_measurements" files ins securityfs, but given that
   those are inside ima there no reason for the indirection at all.



> 
> Mimi
> 
> 
> 
---end quoted text---
