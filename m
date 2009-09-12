Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZILLuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZILLuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZILLub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:50:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45579 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZILLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:50:30 -0400
Date: Sat, 12 Sep 2009 12:50:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <20090912115029.GA14300@sirena.org.uk>
References: <Pine.LNX.4.64.0909111822480.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909111822480.10552@pc-004.diku.dk>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.26.81
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/8] sound/soc: introduce missing kfree
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 06:23:04PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>

> Error handling code following a kzalloc should free the allocated data.
> Error handling code following an ioremap should iounmap the allocated data.

This doesn't seem to be a complete fix for the issue.  There are several
other places where the function can fail but which don't do this cleanup
- this may indicate a problem with the automatic analysis if it fails to
spot the problem in the fixed code?

In general for this sort of issue I'd suggest considering adding the
error handling using the goto unwind block style since that tends to be
a bit more robust against forgotten error handling than adding unwind
code at each error site.  It's also a bit more managable when the code
is doing a series of allocations like this is.
