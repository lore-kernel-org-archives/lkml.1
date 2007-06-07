Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbXFGRAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbXFGRAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbXFGRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:00:01 -0400
Received: from waste.org ([66.93.16.53]:60479 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXFGQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:59:59 -0400
Date: Thu, 7 Jun 2007 11:59:16 -0500
From: Matt Mackall <mpm@selenic.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607165916.GZ11115@waste.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org> <20070607022608.GA2416@localhost.localdomain> <20070607055912.GX11166@waste.org> <20070607065158.GA1996@localhost.localdomain> <20070607140444.GR11115@waste.org> <20070607154007.GA9305@localhost.localdomain> <20070607155913.GW11115@waste.org> <20070607163930.GA11060@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607163930.GA11060@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:39:30AM +0800, WANG Cong wrote:
> >Ketchup doesn't even look inside patches, and patch doesn't invent
> >names, so something in the bzip2 -> patch(1) -> filesystem chain got
> >corrupted. Probably not bzip2, as it has CRCs.
> >
> 
> Do you mean ketchup doesn't do anything if a file is corrupted?

Ketchup never even sees the filenames. It just calls bzip2 | patch. So
it can't be responsible for damaging the filename.
 
> >Do you have ECC memory?
>
> No. Do you mean it's an error of my RAM? I have never met such things before,
> how often does such kind of things happen? May be less often than a bug in
> a stable kernel?

The best studies I've seen suggest so-called "soft errors" in DRAM
happen at a rate of once a week to once a day per gigabyte of RAM at
sea-level. It's unknown how many of these errors manifest by visibly
corrupting data, but it wouldn't be surprising if it were
significantly less than 10%. But ECC is definitely not just for the
paranoid!

So if I were to rank the reliability of everything, it'd look
something like this, highest to lowest:

 bzip: simple, stable and heavily-used codebase, built-in safeguards like CRC
 patch: simple, stable, heavily-used, limited detection of input errors
 CPU: heavily used, very low non-catastrophic failure rate
 disk: heavily used, CRC on cable, ECC on disk
 kernel: complex, rapidly-changing, but heavily-used
 Non-ECC DRAM: significant known transient failure rate
 
When the error rate for the kernel approaches that of DRAM, it gets
very hard to assign blame.

(And of course, there's the user, who tends to be near the bottom of
this range, but I'll let you judge that.)

-- 
Mathematics is the supreme nostalgia of our time.
