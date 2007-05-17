Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXEQReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXEQReU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbXEQReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:34:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbXEQReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:34:09 -0400
Date: Thu, 17 May 2007 10:29:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind@infradead.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-Id: <20070517102931.6bbbad1a.akpm@linux-foundation.org>
In-Reply-To: <1179414590.3642.69.camel@sauron>
References: <20070517143200.GA30850@lst.de>
	<1179413443.3642.49.camel@sauron>
	<20070517145653.GA968@lst.de>
	<1179414590.3642.69.camel@sauron>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy <dedekind@infradead.org> wrote:

> On Thu, 2007-05-17 at 16:56 +0200, Christoph Hellwig wrote:
> > On Thu, May 17, 2007 at 05:50:43PM +0300, Artem Bityutskiy wrote:
> > > Christoph,
> > > 
> > > On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > > > Kill ubis homegrown endianess handling crap and replace it with
> > > > the normal kernel endianess handling.
> > > 
> > > Err,__be32 and the company are just sparse things, while I have compiler
> > > checks with my struct ubi32_t and friends. JFFS2 also uses the same
> > > technique. Why do you force me to rely on sparse instead instead of
> > > compiler?
> > 
> > Yes.  Like all other code in the kernel aswell.
> 
> Andrew, may I please have your ack that I absolutely have to use __be32
> instead of my own types since Christoph tends to provide no explanation
> to his requests.

umm..  I'd say what you've done in there is an improvement to the exiting
stuff: getting gcc to check it is better than having to use sparse.

I'd have expected gcc to generate poorer code with your approach but I'm
showing zero text size changes from Christoph's patch (gcc-4.1 and
gcc-3.4.5).

So I wouldn't be averse to creating a new, generic, kernel-wide alternative
to the existing __be32/__le32/etc code.  It is an improvement.

But I don't think we want driver-private implementations.



We could conceivably simply switch the existing stuff to use structs, but
quite a lot of code assumes that cpu_to_foo32(0) == 0 and just does
open-coded assigments of zero.  They'd need fixups.
