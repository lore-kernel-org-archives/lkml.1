Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXKLTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXKLTyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXKLTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:54:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbXKLTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:54:08 -0500
Date: Mon, 12 Nov 2007 11:53:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
 !CONFIG_BINFMT_AOUT [try #5]
Message-Id: <20071112115353.227f35cb.akpm@linux-foundation.org>
In-Reply-To: <6214.1194881680@redhat.com>
References: <20071110181416.31dc2614.akpm@linux-foundation.org>
	<20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	<20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
	<6214.1194881680@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 15:34:40 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +# -*- makefile -*-
> > 
> > what's that?
> 
> Ah...  That tells emacs that it's a makefile.  In Kbuild.asm emacs thinks its
> an Assembly file and not a makefile.  This causes it to attempt to do
> automatic indentation on it.  Do you want me to drop these annotation
> comments?

Doesn't worry me, but I'd suggest that such annotation be added to all such
files in a single separate patch.

otoh it'd be pretty dumb of emacs if there wasn't some way of telling it
the type of a file external from that file itself.

> > Note that because of unexport-asm-pageh.patch I turned the above hunk into
> > 
> > ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
> > unifdef-y += a.out.h
> > endif
> > 
> > which seems logical to me.  We'll see how it tests out.
> 
> Are you talking about in linux/Kbuild or in asm-generic/Kbuild.asm or both?

I forget which Kbuild file that was.  But with the above change, both
include/asm-generic/Kbuild.asm and include/linux/Kbuild are using
unifdef-y.

> Anyway, it sounds reasonable.
> 
> David
