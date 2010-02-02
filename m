Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0BBK6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:58:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751792Ab0BBK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:58:02 -0500
Date: Tue, 2 Feb 2010 10:58:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: sound tree build failure
Message-ID: <20100202105800.GE6566@rakim.wolfsonmicro.main>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
 <20100202102609.GA6566@rakim.wolfsonmicro.main>
 <20100202213732.586a3566.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202213732.586a3566.sfr@canb.auug.org.au>
X-Cookie: Nothing is but what is not.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:37:32PM +1100, Stephen Rothwell wrote:

> The sound tree is merged before the mfd tree, and the commit that adds
> those is only in the mfd tree.  So the sound tree, on its own, is
> broken.  This driver will only build if you merge the mfd tree as well.

Ah, you're doing builds after each individual merge.  It might help to
change the form you're using when reporting problems with partially
constructed -next - at the minute you say "Today's linux-next build
(x86_64 allmodconfig) failed like this:" which makes it look like you're
testing the result of the full -next merge.

> > > To fix this, the relevant commits from the mfd tree could be put into a
> > > "never to be rebased" branch (or separate git tree) and then this branch
> > > merged into both the sound and mfd trees.

> > This is not needed, Kconfig will handle it.

> Kconfig has nothing to do with it, sorry.

No, it does really fix the problem.  As I said the driver should build
depend on a Kconfig symbol which is introduced in the MFD tree.  This
means that the driver will not be built at all until MFD has been merged
since the dependencies required to select the driver will not be
satisfied unless the commits it depends on are present in the tree.

I'll push a patch for this shortly.
