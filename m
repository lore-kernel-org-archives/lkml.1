Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZGCJc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZGCJc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGCJct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:32:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55547 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbZGCJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:32:48 -0400
Date: Fri, 3 Jul 2009 10:32:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Fix wm8753 register cache size and initialization
Message-ID: <20090703093250.GA29130@rakim.wolfsonmicro.main>
References: <1246574768-11447-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246574768-11447-1-git-send-email-lars@metafoo.de>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 12:46:08AM +0200, Lars-Peter Clausen wrote:

> The register cache size is of by one. There are 63 registers in use but the
> register cache size has only space for 62.

Only 62 of the registers are cached - please see the register cache
access code.

> Furthermore the codec's reg_cache_size is of by another one. Since the wm8753
> register cache uses one-based indexing we have to add one to its size.

I'm not 100% sure what you mean here but I suspect you're misreading the
register cache access code?

> Register cache initialization only copied the first sizeof(void*) elements leaving the others
> uninitialized. Fix it by using the size of the reg cache template.

This fix is good (but should use wm8753->reg_cache for the size).  I'll
fix this.
