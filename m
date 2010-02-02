Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0BBK0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:26:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36136 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753159Ab0BBK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:26:13 -0500
Date: Tue, 2 Feb 2010 10:26:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: sound tree build failure
Message-ID: <20100202102609.GA6566@rakim.wolfsonmicro.main>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
X-Cookie: Nothing is but what is not.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 12:47:11PM +1100, Stephen Rothwell wrote:

> sound/soc/codecs/wm8994.c:30:35: error: linux/mfd/wm8994/core.h: No such file or directory
> sound/soc/codecs/wm8994.c:31:40: error: linux/mfd/wm8994/registers.h: No such file or directory
> sound/soc/codecs/wm8994.c:32:36: error: linux/mfd/wm8994/pdata.h: No such file or directory
> sound/soc/codecs/wm8994.c:33:35: error: linux/mfd/wm8994/gpio.h: No such file or directory

> And went down hill form there :-(

This looks really odd - all those headers are present in the linux-next
tree (and have been for a few days) as far as I can tell, and I can't
see any way they could not be found without serious breakage elsewhere.
Could you please re-run your build with V=1 to show the kernel command
line used to build the driver?  I can't reproduce this here and like I
say I can't see how this could happen given that those files are there
in -next and it's hard to see how this could happen.

> Caused by commit 9e6e96a197a03752d39a63e4f83e0b707ccedad7 ("ASoC: Add
> WM8994 CODEC driver").  I presume that this commit depends on commits
> currently only in the mfd tree ...

Not exactly, there's a Kconfig dependency which should keep track of
things but the wrong one got merged over when things got split out to go
into the several trees.  Though for allmodconfig that will not be
relevant since the dependency will be satisfied anyway and the headers
don't need Kconfig to pull them in.

Like I say, everything required is in the MFD tree in -next anyway.

> I have used the sound tree from next-20100201 for today.

> To fix this, the relevant commits from the mfd tree could be put into a
> "never to be rebased" branch (or separate git tree) and then this branch
> merged into both the sound and mfd trees.

This is not needed, Kconfig will handle it.
