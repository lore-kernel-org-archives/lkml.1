Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZGCKfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZGCKfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZGCKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:35:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50826 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751158AbZGCKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:35:16 -0400
Date: Fri, 3 Jul 2009 11:35:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Fix wm8753 register cache size and initialization
Message-ID: <20090703103517.GE29130@rakim.wolfsonmicro.main>
References: <1246574768-11447-1-git-send-email-lars@metafoo.de>
 <20090703093250.GA29130@rakim.wolfsonmicro.main>
 <4A4DDA51.3070401@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4DDA51.3070401@metafoo.de>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 12:15:45PM +0200, Lars-Peter Clausen wrote:
> Mark Brown wrote:

> >Only 62 of the registers are cached - please see the register cache
> >access code.

> Yes. Thats the problem. The register cache holds place for 62
> elements where as there are 63 register which should be cached.
> In the register cache access code you subtract one from the
> registers index to get it's index in the register cache array, so
> the last register has the index 62. Which means it is the 63th
> element of the array and thus the array has to consist of 63
> elements.

OK, that makes sense.  I will apply your patch with a rewritten commit
message which explains the issue - the problem is not that there is one
less register in the cache than is in use, it's that there is one less
register in the cache than is *cached*.  As I say the code deliberately
doesn't cache one of the registers.

> >I'm not 100% sure what you mean here but I suspect you're misreading the
> >register cache access code?

> The register cache access code uses one-based indexing so the first

Right, that makes sense with the above.
