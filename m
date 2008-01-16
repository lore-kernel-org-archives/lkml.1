Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYAPSUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYAPSUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYAPSUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:20:34 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55659 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYAPSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:20:34 -0500
Message-ID: <478E4A07.1050803@keyaccess.nl>
Date: Wed, 16 Jan 2008 19:16:39 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jaroslav Kysela <perex@perex.cz>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@suse.cz>, Ondrej Zary <linux@rainbow-software.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
 breaks resuming isapnp cards
References: <200801092343.48726.linux@rainbow-software.org> <200801141526.57744.bjorn.helgaas@hp.com> <Pine.LNX.4.61.0801150842480.7446@tm8103.perex-int.cz> <200801161046.05174.bjorn.helgaas@hp.com>
In-Reply-To: <200801161046.05174.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-01-08 18:46, Bjorn Helgaas wrote:

> On Tuesday 15 January 2008 12:51:35 am Jaroslav Kysela wrote:

>> Ok, something to explain. These flags exists to allow drivers to 
>> manually configure (override) PnP resources at init time - we know - for 
>> example in ALSA - that some combinations simply does not work for all 
>> soundcards.
>>
>> The DISABLE flags simply tells core PnP layer - driver will handle 
>> resource allocation itself, don't do anything, just disable hw physically 
>> and do not change (allocate) any resources. Value 0x03 is valid in this 
>> semantics.
> 
> It looks like sound drivers use PNP_DRIVER_RES_DISABLE to say "ignore
> what PNP tells us about resource usage and we'll just use the compiled-
> in or command-line-specified resources".
> 
> The main reason to do that would be to work around BIOS defects or
> to work around deficiencies in the Linux PNP infrastructure (e.g.,
> maybe we erroneously place another device on top of the sound card
> or something).
> 
> I'm just suspicious because PNP_DRIVER_RES_DISABLE is only used in
> sound drivers.  If it's to work around BIOS defects, why wouldn't
> other PNP drivers need it sometimes, too?  And wouldn't it be better
> to use PNP quirks for BIOS workarounds?

Yes. The manual resource setting was recently removed from the ALSA drivers 
and I'd expect this can now go as a package-deal.

>> Unfortunately, suspend / resume complicates things a bit, but PnP core can 
>> handle DO_NOT_CHANGE flag. But it will just mean - _preserve_ resource 
>> allocation from last suspend state for this device and enable hw 
>> physically before calling resume() callback.
> 
> When resuming, wouldn't we *always* want to preserve the resource
> allocation from the last suspend, regardless of whether
> PNP_DRIVER_RES_DO_NOT_CHANGE is specified?

Yes.

> Linux PNP definitely has issues with suspend/resume, and I suspect
> this is one of them.

Rene.
