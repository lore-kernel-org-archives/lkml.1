Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYESEnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYESEnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYESEnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:43:12 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42480 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785AbYESEnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:43:12 -0400
Date: Mon, 19 May 2008 13:41:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: Magical stack pointer index, for NEW_AUX_ENT compat.
Message-ID: <20080519044141.GA10077@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080516090150.GA16496@linux-sh.org> <12478.1210936953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12478.1210936953@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:22:33PM +0100, David Howells wrote:
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > While implementing binfmt_elf_fdpic on SH it quickly became apparent
> > that SH was the first platform to support both binfmt_elf_fdpic and
> > binfmt_elf, as well as the only of the FDPIC platforms to make use of the
> > auxvt.
> > 
> > Currently binfmt_elf_fdpic uses a special version of NEW_AUX_ENT() where
> > the first argument is the entry displacement after csp has been adjusted,
> > being reset after each adjustment. As we have no ability to sort this out
> > through the platform's ARCH_DLINFO, this index needs to be managed
> > entirely in create_elf_fdpic_tables(). Presently none of the platforms
> > that set their own auxvt entries are able to do so through their
> > respective ARCH_DLINFOs when using binfmt_elf_fdpic.
> > 
> > In addition to this, binfmt_elf_fdpic has been looking at
> > DLINFO_ARCH_ITEMS for the number of architecture-specific entries in the
> > auxvt. This is legacy cruft, and is not defined by any platforms in-tree,
> > even those that make heavy use of the auxvt. AT_VECTOR_SIZE_ARCH is
> > always available, and contains the number that is of interest here, so we
> > switch to using that unconditionally as well.
> > 
> > As this has direct bearing on how much stack is used, platforms that have
> > configurable (or dynamically adjustable) NEW_AUX_ENT calls need to either
> > make AT_VECTOR_SIZE_ARCH more fine-grained, or leave it as a worst-case
> > and live with some lost stack space if those entries aren't pushed (some
> > platforms may also need to purposely sacrifice some space here for
> > alignment considerations, as noted in the code -- although not an issue
> > for any FDPIC-capable platform today).
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Acked-by: David Howells <dhowells@redhat.com>

As the SH FDPIC stuff depends on this, I'll fold this in to my 2.6.27
tree with the above Acked-by, which will trickle in to -mm and linux-next
directly.
