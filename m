Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXK0Uwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXK0Uwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXK0UwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:52:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237AbXK0UwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:52:21 -0500
Date: Tue, 27 Nov 2007 12:51:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: udovdh@xs4all.nl, linux-kernel@vger.kernel.org, mb@bu3sch.de,
       folkert@vanheusden.com
Subject: Re: enable dual rng on VIA C7
Message-Id: <20071127125109.a2ef96f2.akpm@linux-foundation.org>
In-Reply-To: <20071127185053.GA30057@redhat.com>
References: <47374EA4.1060009@xs4all.nl>
	<20071125233949.f64b2ecd.akpm@linux-foundation.org>
	<474AFC2F.1040309@xs4all.nl>
	<20071126185843.GD15764@redhat.com>
	<474C40FA.1070501@xs4all.nl>
	<20071127185053.GA30057@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 13:50:53 -0500
Dave Jones <davej@redhat.com> wrote:

> On Tue, Nov 27, 2007 at 05:08:26PM +0100, Udo van den Heuvel wrote:
>  > Dave Jones wrote:
>  > > On Mon, Nov 26, 2007 at 06:02:39PM +0100, Udo van den Heuvel wrote:
>  > > 
>  > >  > I did not know we are already that far ;-)
>  > >  > I mean: can this patch be aplied without hurting C3/C7 CPU's with just
>  > >  > one RNG? Maybe an expert needs to test/answer?
>  > >  > Maybe some logic needs to be applied around the extra bit?
>  > >  
>  > >>From the padlock spec..
>  > > 
>  > > "SRC Bits[9:8] Noise source select (I): These bits control the two noise
>  > >  sources on the processor that input bits to the accumulation buffers.
>  > >  On Nehemiah processors prior to stepping 8, these bits are reserved
>  > >  and undefined. The default RESET state is both bits = 0." 
>  > > 
>  > > Something like this perhaps ?
>  > 
>  > Yes, I think that's a big step in the right direction!
>  > 
>  > But I am no expert and cannot really judge how necessary or correct the
>  > implementation is w.r.t. the 'undefined' function bits for CPU's that
>  > lack a certain feature.
> 
> The checks at the end of the patch for the x86_mask/model ensure
> we only enable the 2nd noise source on CPUs documented to have it,
> so we should be safe.
> 
> Andrew, want to throw that in the -mm pile for a while?
> 

Did that, renamed to "via-rng: enable secondary noise source on CPUs where
it is present".

Has anyone tested it?
