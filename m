Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZGPNXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZGPNXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZGPNXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:23:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53629 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755877AbZGPNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:23:10 -0400
Date: Thu, 16 Jul 2009 14:23:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jaroslav Kysela <erex@perex.cz>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/06] Fix compilation warning for
 sound/soc/codecs/wm8400.c
Message-ID: <20090716132308.GC9656@rakim.wolfsonmicro.main>
References: <20090716130958.28045.71072.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716130958.28045.71072.sendpatchset@subratamodak.linux.ibm.com>
X-Cookie: They just buzzed and buzzed...buzzed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 06:40:01PM +0530, Subrata Modak wrote:

> How about the following brutal shutdown ?

No, this is the patch you originally submitted.  You are missing the
point here - your patches are all just papering over the warning and
won't help at all if there is an actual problem.

> 'factors' will get initialized here, as, 'freq_out' will probably never have
> a '0' value. So, 'fll_factors()' will actually overwrite values in 'factors'
> even after the initial brutal assignment:
> 	"struct fll_factors factors = {}"

This is pretty much the point of the warning when it's valid - it's
trying to catch situations where there is a code path where the variable
is used without being initialised.  If you just blindly initialise the
variable as you are doing then the warning goes away but any problematic
code remains so the situation is worse.

In this case I suspect that whatever compiler you are using (none of
those I've tried with seem to be doing this) isn't able to figure out
that if we skip initialising the variable then we use exactly the same
condition to return from the function before we try to use the variable.
For something like this the warning can normally be worked around by
changing the control flow so that the compiler is able to figure out
that things are safe.
