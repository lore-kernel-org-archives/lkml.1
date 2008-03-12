Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYCLL4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYCLL4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYCLLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:55:56 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:1707 "EHLO
	scmp07.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbYCLLzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:55:42 -0400
Message-ID: <47D7C464.7060909@draigBrady.com>
Date: Wed, 12 Mar 2008 11:54:12 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Samuel Tardieu <sam@rfc1149.net>
CC: Wim Van Sebroeck <wim@iguana.be>, junker@anduras.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: w83697hf_wdt.c stops watchdog on load
References: <47D564CA.1040507@draigBrady.com> <2008-03-10-18-48-16+trackit+sam@rfc1149.net> <47D5C1DC.6080808@draigBrady.com> <20080311202214.GA7505@infomag.infomag.iguana.be> <2008-03-11-21-28-21+trackit+sam@rfc1149.net>
In-Reply-To: <2008-03-11-21-28-21+trackit+sam@rfc1149.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Mar 2008 11:54:15.0163 (UTC) FILETIME=[CB75ECB0:01C88437]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXUniqueID: e3f962e2-8a27-40a3-979f-0f99ea46e11a
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Tardieu wrote:
> On 11/03, Wim Van Sebroeck wrote:
> 
> | > > Isn't it a two-edged sword?
> | > 
> | > True, but one should be able to set things up so that there is no race.
> | > I.E. if you add the autodisable, it should only be done as an option.
> | > Best have it =no by default, but as least one could turn this off.
> | 
> | In my opinion it should be the other way around: the default behaviour is to
> | stop the watchdog and to let userspace (the watchdog-daemon) control the
> | watchdog. So if we add a module parameter to take over the watchdog's
> | bios-setting, then the default behaviour should be to stop the watchdog and
> | add an option that takes the value from the bios.
> 
> Hi Wim.
> 
> That was my intent: disable the watchdog by default

When doing this it would be useful to print a warning iif the watchdog was running.
I.E. the following would be possible for the w83697:

init() {
  if (watchdog_already_running) {
     printk("warning, stopping watchdog. Use the nodisable option to keep running");
     disable_watchdog();
  }
}

See the w83627 driver for how to determine watchdog is running.

>, and add an option
> not to disable it (let it untouched, so getting the BIOS setting) at
> module initialization, as Pádraig request is totally reasonable.

cool, thanks.

Pádraig.

p.s. I'm still not sure it should default to turning off.
It would be unusual for userspace to take over 60s to _start_
If that was the case then the user shouldn't enable the watchdog in the BIOS at all.
