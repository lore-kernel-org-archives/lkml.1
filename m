Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYANXtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYANXtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYANXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:49:45 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44324 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYANXto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:49:44 -0500
Message-ID: <478BF449.2050307@keyaccess.nl>
Date: Tue, 15 Jan 2008 00:46:17 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@suse.cz>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
 breaks resuming isapnp cards
References: <200801092343.48726.linux@rainbow-software.org> <200801122250.44220.bjorn.helgaas@hp.com> <4789AC0F.9030007@keyaccess.nl> <200801141526.57744.bjorn.helgaas@hp.com>
In-Reply-To: <200801141526.57744.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-08 23:26, Bjorn Helgaas wrote:

> On Saturday 12 January 2008 11:13:35 pm Rene Herman wrote:

>> I find DISABLE including DO_NOT_CHANGE rather unexpected...
> 
> I don't know the history of those flags, but I wish they didn't exist.
> They really look like warts in the PNP core code.  They're used so
> infrequently and without obvious rationale, that it seems like it'd
> be better if there were a way to deal with them inside the driver.

I see, thanks for the comment. PNP_DRIVER_RES_DISABLE is used by ALSA only 
and used by _all_ ALSA ISA-PnP drivers (snd-sscape uses RES_DO_NOT_CHANGE 
instead but we should consider that one a consistency bug).

RES_DO_NOT_CHANGE is used by drivers/pnp/system.c and rtc-cmos.c as well. 
I'll look at this. Getting rid of DISABLE as a first step should not be 
overly problematic. This might again be a left-over from days where no easy 
to use interface to PnP existed which it now does in echoing things into sysfs.

Takashi: which reminds me -- crap, I promised to document more of that for 
ALSA use following up the recent pnp driver-side resource setting removal. 
Sorry, forgot, will do.

> This had to do with the excessive warnings about exceeding the maximum
> number of resources for a PNP device.  This should be resolved by Len's
> patch here:
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=9535#c10
> 
> We all agree this is a stop-gap, and for 2.6.25, we need the real
> solution of making PNP resources fully dynamic.

Thank you. Just pulled and see that's now indeed in. Wasn't in -rc7 yet...

Rene.
