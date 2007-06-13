Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbXFMFqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbXFMFqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXFMFpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:45:52 -0400
Received: from science.horizon.com ([192.35.100.1]:17073 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754367AbXFMFpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:45:51 -0400
Date: 13 Jun 2007 01:45:21 -0400
Message-ID: <20070613054521.18992.qmail@science.horizon.com>
From: linux@horizon.com
To: akpm@linux-foundation.org, linux@horizon.com, mpm@selenic.com
Subject: Re: [PATCH] random: fix folding
Cc: bgilbert@cs.cmu.edu, linux-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20070613052951.GI11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Folding is done to minimize the theoretical possibility of systematic
> weakness in the particular bits of the SHA1 hash output. The result of
> this bug is that 16 out of 80 bits are un-folded. Without a major new
> vulnerability being found in SHA1, this is harmless, but still worth
> fixing.

Actually, even WITH a major new vulnerability found in SHA1, it's
harmless.  Sorry to put BUG in caps earlier; it actually doesn't warrant
the sort of adjective I used.  The purpose of the folding is to ensure that
the feedback includes bits underivable from the output.  Just outputting
the first 80 bits and feeding back all 160 would achieve that effect;
the folding is of pretty infinitesimal benefit.

Note that last five rounds have as major outputs e, d, c, b, and a,
in that order.  Thus, the first words are the "most hashed" and
the ones most worth using as output... which happens naturally with
no folding.

The folding is a submicroscopic bit of additional mixing.
Frankly, the code size savings probably makes it worth deleting it.
(That would also give you more flexibility to select the output/feedback
ratio in whatever way you like.)
