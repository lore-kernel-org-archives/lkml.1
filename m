Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXK0Svz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXK0Svz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbXK0SvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:51:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbXK0SvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:51:14 -0500
Date: Tue, 27 Nov 2007 13:50:53 -0500
From: Dave Jones <davej@redhat.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       folkert van Heusden <folkert@vanheusden.com>
Subject: Re: enable dual rng on VIA C7
Message-ID: <20071127185053.GA30057@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	folkert van Heusden <folkert@vanheusden.com>
References: <47374EA4.1060009@xs4all.nl> <20071125233949.f64b2ecd.akpm@linux-foundation.org> <474AFC2F.1040309@xs4all.nl> <20071126185843.GD15764@redhat.com> <474C40FA.1070501@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C40FA.1070501@xs4all.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 05:08:26PM +0100, Udo van den Heuvel wrote:
 > Dave Jones wrote:
 > > On Mon, Nov 26, 2007 at 06:02:39PM +0100, Udo van den Heuvel wrote:
 > > 
 > >  > I did not know we are already that far ;-)
 > >  > I mean: can this patch be aplied without hurting C3/C7 CPU's with just
 > >  > one RNG? Maybe an expert needs to test/answer?
 > >  > Maybe some logic needs to be applied around the extra bit?
 > >  
 > >>From the padlock spec..
 > > 
 > > "SRC Bits[9:8] Noise source select (I): These bits control the two noise
 > >  sources on the processor that input bits to the accumulation buffers.
 > >  On Nehemiah processors prior to stepping 8, these bits are reserved
 > >  and undefined. The default RESET state is both bits = 0." 
 > > 
 > > Something like this perhaps ?
 > 
 > Yes, I think that's a big step in the right direction!
 > 
 > But I am no expert and cannot really judge how necessary or correct the
 > implementation is w.r.t. the 'undefined' function bits for CPU's that
 > lack a certain feature.

The checks at the end of the patch for the x86_mask/model ensure
we only enable the 2nd noise source on CPUs documented to have it,
so we should be safe.

Andrew, want to throw that in the -mm pile for a while?

	Dave

-- 
http://www.codemonkey.org.uk
