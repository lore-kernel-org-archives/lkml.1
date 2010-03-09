Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0CIVER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:04:17 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39157 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0CIVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:04:15 -0500
Date: Tue, 9 Mar 2010 16:02:31 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
In-Reply-To: <alpine.DEB.2.00.1003091454210.28897@router.home>
Message-ID: <alpine.LFD.2.00.1003091559220.12433@localhost>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <20100309122253.3f3d4a53.akpm@linux-foundation.org> <alpine.LFD.2.00.1003091530230.11928@localhost> <alpine.DEB.2.00.1003091454210.28897@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Christoph Lameter wrote:

> On Tue, 9 Mar 2010, Robert P. J. Day wrote:
>
> > > I'm having trouble working out whether we want to backport this into
> > > 2.6.33.x or earlier.  Help?
> >
> >   given the above aesthetic mod, shouldn't that same change be
> > applied to *all* explicit loops of that form?  after all,
> > checkpatch.pl warns against it:
>
> The number of NR_CPUS should be significantly less after the percpu
> rework. Would you audit the kernel for NR_CPUS use?

  i just did a simple grep for the obvious pattern:

$ grep -r "for.*NR_CPUS" *
arch/sparc/mm/init_64.c:	for (i = 0; i < NR_CPUS; i++)
arch/sparc/kernel/sun4d_smp.c:	for (i = 0; i < NR_CPUS; i++) {
arch/sparc/kernel/traps_64.c:	for (i = 0; i < NR_CPUS; i++) {
... etc etc ...

  most of the occurrences are under arch/.  as you say, after the
rework, most of those should be replaceable.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
