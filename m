Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYLCUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYLCUiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbYLCUZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:25:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbYLCUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:25:46 -0500
Date: Wed, 3 Dec 2008 15:25:43 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
Message-ID: <20081203202543.GA16279@infradead.org>
References: <20081203201320.GA17785@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203201320.GA17785@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 02:13:20PM -0600, Serge E. Hallyn wrote:
> > Can you explain what all this template stuff is about?  The only method
> > of these ever called is display_template,
> 
> I'm not sure what you mean here - must_measure for instance is used (in
> patch 3) in the integrity hooks (i.e. file_mmap) to decide whether or not 
> the object (action target) must be measured.

ima_must_measure (or the other implementation bits) are called a lot.
But never through the indirection I quoted.

> > and that seems to be better
> > implented directly as a securityfs file, without the indirection.
> 
> That comment doesn't make sense to me (unless you're saying to punt
> on the generic integrity infrastructure and hook all of the IMA
> code straight into the kernel) so I suspect I'm misreading
> something.

ima_measurements_show alaways calls ima_template_show, and both are
implemented inside the ima module.  There's absolutely no point for the
indirection here.

