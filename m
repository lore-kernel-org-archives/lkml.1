Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbZDIOZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbZDIOZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbZDIOZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:25:34 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53026 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbZDIOZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:25:33 -0400
Date: Thu, 9 Apr 2009 16:25:53 +0200
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, os@emlix.com, dhowells@redhat.com,
       rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
       vapier.adi@gmail.com, gerg@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
Message-ID: <20090409142553.GA3330@emlix.com>
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com> <20090310073350.GH10393@linux-sh.org> <20090402135343.d18d17a5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402135343.d18d17a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:53:43PM -0700, Andrew Morton wrote:
> On Tue, 10 Mar 2009 16:33:50 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > On Thu, Mar 05, 2009 at 06:00:59PM +0100, Oskar Schirmer wrote:
> > > The flat loader uses an architecture's flat_stack_align() to align the
> > > stack but assumes word-alignment is enough for the data sections.
> > > 
> > > However, on the Xtensa S6000 we have registers up to 128bit width
> > > which can be used from userspace and therefor need userspace stack and
> > > data-section alignment of at least this size.
> > > 
> > > This patch drops flat_stack_align() and uses the same alignment that
> > > is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
> > > not defined by the architecture.
> > > 
> > > It also fixes m32r which was obviously kaput, aligning an
> > > uninitialized stack entry instead of the stack pointer.
> > > 
> > > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > > Signed-off-by: Johannes Weiner <jw@emlix.com>
> > > Cc: David Howells <dhowells@redhat.com>
> > > Cc: Russell King <rmk@arm.linux.org.uk>
> > > Cc: Bryan Wu <cooloney@kernel.org>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Paul Mundt <lethal@linux-sh.org>
> > > Cc: Greg Ungerer <gerg@uclinux.org>
> > > Cc: Mike Frysinger <vapier.adi@gmail.com>
> > 
> > The updated version looks ok to me anyways, and it's certainly an
> > improvement over defining the same alignment requirements all over the
> > place.
> > 
> > Acked-by: Paul Mundt <lethal@linux-sh.org>
> 
> Quite a few people expressed quite a few reservations over v2.
> 
> Are we all OK with a v3 merge?

Paul and Mike had complaints.  Paul acked the last revision.  Mike?
We need this for upstream to compile on our configuration.

	Hannes
