Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXEQSUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXEQSUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXEQSUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:20:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbXEQSUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:20:42 -0400
Date: Thu, 17 May 2007 11:18:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind@infradead.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-Id: <20070517111838.842a29ca.akpm@linux-foundation.org>
In-Reply-To: <1179424006.3642.84.camel@sauron>
References: <20070517143200.GA30850@lst.de>
	<1179413443.3642.49.camel@sauron>
	<20070517145653.GA968@lst.de>
	<1179414590.3642.69.camel@sauron>
	<20070517102931.6bbbad1a.akpm@linux-foundation.org>
	<1179424006.3642.84.camel@sauron>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 20:46:46 +0300
Artem Bityutskiy <dedekind@infradead.org> wrote:

> On Thu, 2007-05-17 at 10:29 -0700, Andrew Morton wrote:
> > umm..  I'd say what you've done in there is an improvement to the exiting
> > stuff: getting gcc to check it is better than having to use sparse.
> > 
> > I'd have expected gcc to generate poorer code with your approach but I'm
> > showing zero text size changes from Christoph's patch (gcc-4.1 and
> > gcc-3.4.5).
> > 
> > So I wouldn't be averse to creating a new, generic, kernel-wide alternative
> > to the existing __be32/__le32/etc code.  It is an improvement.
> > 
> > We could conceivably simply switch the existing stuff to use structs, but
> > quite a lot of code assumes that cpu_to_foo32(0) == 0 and just does
> > open-coded assigments of zero.  They'd need fixups.
> 
> Andrew,
> 
> thanks for answer. I personally do not think this should be applied
> before we have better __be32 and friends. Thus, if I can do so, I will
> just sit and wait for your decision - whether you include this patch to
> -mm or not :-) .
> 

Drat, and here was I hoping I'd lured you into implementing the generic
code.

