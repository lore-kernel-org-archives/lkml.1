Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842Ab0ASJY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0ASJY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818Ab0ASJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:24:56 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:45422 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0ASJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:24:55 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Tue, 19 Jan 2010 10:25:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001181800.38574.oliver@neukum.org> <201001182141.49907.rjw@sisk.pl>
In-Reply-To: <201001182141.49907.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191025.37579.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. Januar 2010 21:41:49 schrieb Rafael J. Wysocki:
> On Monday 18 January 2010, Oliver Neukum wrote:
> > Am Sonntag, 17. Januar 2010 14:55:55 schrieb Rafael J. Wysocki:
> > > +void mm_force_noio_allocations(void)
> > > +{
> > > +       /* Wait for all slowpath allocations using the old mask to complete */
> > > +       down_write(&gfp_allowed_mask_sem);
> > > +       saved_gfp_allowed_mask = gfp_allowed_mask;
> > > +       gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
> > > +       up_write(&gfp_allowed_mask_sem);
> > > +}
> > 
> > In addition to this you probably want to exhaust all memory reserves
> > before you fail a memory allocation
> 
> I'm not really sure what you mean.

Forget it, it was foolish. Instead there's a different problem.
Suppose we are tight on memory. The problem is that we must not
exhaust all memory. If we are really out of memory we may be unable
to satisfy memory allocations in resume()

	Regards
		Oliver
