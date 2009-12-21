Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZLUVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZLUVR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbZLUVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:17:27 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24664 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbZLUVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:17:26 -0500
Date: Mon, 21 Dec 2009 14:17:24 -0700
From: Alex Chiang <achiang@hp.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       venkatesh.pallipadi@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] ACPI: early _PDC eval and unify x86/ia64
Message-ID: <20091221211724.GB28569@ldl.fc.hp.com>
References: <20091220190434.4274.67855.stgit@bob.kio> <20091221081550.GA1648@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221081550.GA1648@isilmar.linta.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dominik Brodowski <linux@dominikbrodowski.net>:
> 
> On Sun, Dec 20, 2009 at 12:19:04PM -0700, Alex Chiang wrote:
> > This does introduce a boot time namespace walk for all the CPUs
> > in the system, looking for and evaluating _PDC. Hopefully that
> > will not make life miserable for the giant SGI clusters. If worse
> > comes to worse, maybe we can quirk them and avoid the namespace
> > walk.
> 
> Could this be done async, with completion before EC initialization?

I don't think I understand your suggestion.

On some platforms, we need to finish evaluating _PDC before we
initialize the EC. That's what I discovered with the Envy 15. At
that point in boot, we're single-threaded and going through early
ACPI initialization. Each step has to finish before the next, in
order for later initialization to succeed.

There's nothing else going on except for waiting for _PDC to
finish so that we can initialize the EC.

My fear was that on a huge compute cluster, walking the namespace
for every CPU object to evaluate _PDC might take a long time, and
is also probably unnecessary, since their hardware/firmware
probably doesn't load dynamic tables in _PDC.

In that case, my suggestion was to avoid the walk with a quirk.

But maybe it's not necessary to worry about that until it's
actually proven to be a problem.

Thanks,
/ac

