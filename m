Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbYAMGRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbYAMGRC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 01:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYAMGQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 01:16:53 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41924 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYAMGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 01:16:52 -0500
Message-ID: <4789AC0F.9030007@keyaccess.nl>
Date: Sun, 13 Jan 2008 07:13:35 +0100
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
References: <200801092343.48726.linux@rainbow-software.org> <200801122008.10313.rjw@sisk.pl> <47891E21.8060209@keyaccess.nl> <200801122250.44220.bjorn.helgaas@hp.com>
In-Reply-To: <200801122250.44220.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-01-08 06:50, Bjorn Helgaas wrote:

> On Saturday 12 January 2008 1:08:01 pm Rene Herman wrote:

>> pnp-do-not-stop-start-devices-in-suspend-resume-path.patch in current -mm
>> breaks resuming isapnp cards from hibernation. They need the pnp_start_dev
>> to enable the device again after hibernation.
>>
>> They don't really need the pnp_stop_dev() which the above mentioned patch
>> also removes but with the pnp_start_dev() restored it seems pnp_stop_dev()
>> should also stay. Bjorn Helgaas should decide  -- currently the patch as
>> you have it breaks drivers though. Could you drop it?
> 
> Yes, please drop pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
> for now.

Okay, thanks for the reply. And, now that I have your attention, while it's 
not important to the issue anymore with the tests removed as the submitted 
patch did, do you have an opinion on (include/linux/pnp.h):

/* pnp driver flags */
#define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
of the device */
#define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
disabled */

I find DISABLE including DO_NOT_CHANGE rather unexpected...

By the way, I also still have this next one outstanding for you... :-/

http://lkml.org/lkml/2008/1/9/168

Rene.
