Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbYBFJKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbYBFJKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbYBFJJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:09:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759602AbYBFJJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:09:54 -0500
Date: Wed, 6 Feb 2008 01:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-Id: <20080206010947.7b3e9d5e.akpm@linux-foundation.org>
In-Reply-To: <1202288778.31295.2.camel@localhost>
References: <20071112143009.425807965@de.ibm.com>
	<20071112144009.831296895@de.ibm.com>
	<20080201151541.8e3e0359.akpm@linux-foundation.org>
	<1202017020.7208.2.camel@pasglop>
	<20080202215315.3ac6907d.akpm@linux-foundation.org>
	<1202121409.31801.7.camel@localhost>
	<20080204025133.511ac3e2.akpm@linux-foundation.org>
	<1202222388.25021.20.camel@localhost>
	<20080205104625.60fa86b0.akpm@linux-foundation.org>
	<1202288778.31295.2.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 10:06:18 +0100 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Tue, 2008-02-05 at 10:46 -0800, Andrew Morton wrote:
> > > I got x86-64 compiled by removing the #include <asm/pgalloc.h> from
> > > asm-generic/tlb.h. But who knows what will break if the include is
> > > missing .. I'll cross compile some of the other architectures next.
> > > 
> > 
> > urgh, well, thanks for trying.  If there's significant risk factor (or
> > hassle) in fixing the macros then I'd suggest we not do it for now - it's a
> > separate project.
> 
> I'm still at it. I does make sense to convert the damn macros to inline
> functions. The question now is the order of things, the macro cleanup
> first or the sub-page page tables first? I would prefer the sub-page
> page tables first since that code has been hanging around in -mm for a
> while and could go upstream after I regenerated the patch and test
> compiled it again. We do need it for KVM and we want to push our KVM
> patches for s390 soon.

I'd suggest do the macro ceanup later.  That's the sort of thing which we
can/should trickle through arch maintainers.

