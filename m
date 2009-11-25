Return-Path: <linux-kernel-owner+w=401wt.eu-S935104AbZKYVu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbZKYVu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935073AbZKYVu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:50:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934901AbZKYVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:50:28 -0500
Date: Wed, 25 Nov 2009 16:50:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091125215018.GB4916@infradead.org>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my2bwtno.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:32:27PM +0100, Andi Kleen wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > From: Roland McGrath <roland@redhat.com>
> >
> > This adds the utrace facility, a new modular interface in the kernel
> > for implementing user thread tracing and debugging.  This fits on top
> > of the tracehook_* layer, so the new code is well-isolated.
> 
> Could we just drop the tracehook layer if this finally merged
> and call the low level functions directly?
> 
> It might have been reasonably early on when it was still out of tree,
> but longer term when it's integrated having strange opaque hooks
> like that just makes the coder harder to read and maintain.

I agree that linux/tracehook.h as a separate layer is pretty annoying,
but a lot of the helper actually are quite useful.  I'd suggest to throw
a patch ontop of the series to rename all the useful macros to utrace_
and move them into utrace.h and just remove those that are really
trivial wrappers.

