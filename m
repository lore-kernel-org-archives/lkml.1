Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZHLE00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZHLE00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZHLE00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:26:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:53864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZHLE0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:26:25 -0400
Date: Tue, 11 Aug 2009 21:28:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
Message-ID: <20090811212842.4291eba0@infradead.org>
In-Reply-To: <20090811143643.GA15096@us.ibm.com>
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
	<20090811143643.GA15096@us.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 09:36:43 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting James Morris (jmorris@namei.org):
> > I think it'd be a good idea to constify more of the various
> > operations structs in the kernel -- our coverage of this is spotty.
> > 
> > The patch below should provide coverage for all of the eligible 
> > seq_operations structs in the kernel.  It's derived from the
> > grsecurity patch (which I was reading and noticed how many of these
> > we're missing).
> > 
> > It's possible something's been missed, or that there are problems
> > in code which I can't test.  Please review/comment/test.
> > 
> > If it looks ok, I suggest pushing this via -mm.
> > 
> > Note that there are quite a few other similar ops to be constified,
> > such as file_operations, so if anyone would like to pitch in,
> > please do so.
> > 
> > ---
> > 
> > Subject: [PATCH 1/1] security: constify seq_operations
> > 
> > Make all seq_operations structs const, to help mitigate
> > against revectoring user-triggerable function pointers.
> > 
> > This is derived from the grsecurity patch, although generated
> > from scratch because it's simpler than extracting the changes
> > from there.
> > 
> > Signed-off-by: James Morris <jmorris@namei.org>
> 
> I think it's a good idea.
> 
> I suppose we could add a script to check for any new
> seq_ops structs not constified...  something as simple as
> find . -type f -print0 | xargs -0 grep 'struct seq_operations' | grep
> -v const Though what you have here hits all of those and more.
> 
that's what checkpatch.pl is for
(afaik it does that already for file_operations)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
