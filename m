Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJ2Msk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJ2Msk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYJ2Msb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:48:31 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:35909 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYJ2Msa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:48:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <49085BA9.8050306@cam.ac.uk>
Date: Wed, 29 Oct 2008 12:48:41 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Liam Girdwood <lrg@kernel.org>, felipe.balbi@nokia.com,
       eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support
 go?
References: <4906F500.7080100@cam.ac.uk> <20081028112341.GF27144@gandalf.research.nokia.com> <1225195382.28382.168.camel@dell-desktop.example.com> <4908547C.4090907@gmail.com> <20081029122705.GA14648@sirena.org.uk>
In-Reply-To: <20081029122705.GA14648@sirena.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Oct 29, 2008 at 12:18:04PM +0000, Jonathan Cameron wrote:
> 
>> ADC
>>     Used partly for internal monitoring functionality, partly for
>>     auxiliary inputs.  The question on this is whether to implement
>>     it as a hwmon driver (somewhat unusual form, but sort of fits)
>>     or whether some of this is needed for feedback to the battery
>>     charger code etc.
> 
> For WM8350 this is implemented as a device-specific function in the
> driver core which is then used by other drivers to export the
> information to relevant subsystems.
Seems a sensible option.  Can always put a hwmon driver on top of that
if people want the nice userspace interfaces etc.
 
> There was some work on a generic ADC framework that might be a better
> fit for the auxiliary inputs but I'm not sure where that's going ATM or
> if it's really appropriate.
That's probably me anyway (industrialio), it's stalled whilst I switch
my test platform to this driver and isn't really suitable for this 
(unless someone wants to abuse the auxiliary adc inputs for general
purpose stuff).

It's focus (principally) is on fast capture from sensors by triggering events
(periodic timers / gpio / non periodic triggering schedules - haven't done
that one yet) rather than internal monitoring.  Other such as input / hwmon
may be built on top of the underlying core, but that's not done yet.

As a quick and dirty progress report, the device handling side of things
is in place and working well. Current work is on generalizing the triggering
framework and working out how to handle the connectivity issues cleanly.
I did promise to post a release at the end of last week but have dropped
back a chunk as some 'minor' changes proved rather complex to do.

Jonathan


 

