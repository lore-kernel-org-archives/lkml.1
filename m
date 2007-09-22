Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbXIVHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbXIVHGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbXIVHGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 03:06:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760262AbXIVHGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 03:06:15 -0400
Date: Sat, 22 Sep 2007 09:06:13 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 7/7] Add documentation for extended crashkernel syntax
Message-ID: <20070922070612.GA6125@suse.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20070913161428.343951643@strauss.suse.de> <20070913161430.686458007@strauss.suse.de> <20070918172108.GD5966@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918172108.GD5966@ucw.cz>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2007-09-18 19:21]:
> > This adds the documentation for the extended crashkernel syntax into
> > Documentation/kdump/kdump.txt.
> 
> Should you also update kernel-parameters.txt?

Ok, I'll do.

> > +For example:
> > +
> > +    crashkernel=512M-2G:64M,2G-:128M
> > +
> > +This would mean:
> > +
> > +    1) if the RAM is smaller than 512M, then don't reserve anything
> > +       (this is the "rescue" case)
> > +    2) if the RAM size is between 512M and 2G, then reserve 64M
> > +    3) if the RAM size is larger than 2G, then reserve 128M
> 
> Why is this useful? I mean... if 64M is enough to save a dump, why use
> 128M? ...or does the required size somehow scale with memory in
> machine? (pagetables?)

A bit, yes (ELF core headers, DISCONT memory, per-CPU data), but
consider also that saving may be faster if you have more RAM (e.g.
saving over SSH, encryption, ...).


Thanks,
   Bernhard
