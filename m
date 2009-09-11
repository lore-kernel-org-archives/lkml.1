Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZIKJWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZIKJWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZIKJWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:22:08 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:41176 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZIKJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:22:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AAA16C8.9030904@cam.ac.uk>
Date: Fri, 11 Sep 2009 10:22:16 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: RFC: Light sensors, unifying current options?
References: <4A9FC9D7.20000@cam.ac.uk> <1252308744.3483.414.camel@rzhang-dt>	 <4AA4F194.1070507@cam.ac.uk> <1252467684.3483.446.camel@rzhang-dt>	 <4AA79144.8060104@cam.ac.uk> <1252546449.3483.476.camel@rzhang-dt>	 <4AA8CF57.4010409@cam.ac.uk> <1252634101.3483.514.camel@rzhang-dt>
In-Reply-To: <1252634101.3483.514.camel@rzhang-dt>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> so, if there are two sensors that support visible and infrared,
> sensor 1:
> illuminance:	xxx
> infrared:	yyy
> sensor 2:
> illuminance:	xxx
> infrared:	yyy
> 
> does this mean the ambient light of these two sensors are the same?
If the values are the same, then probably up to variations in the
sensitivity of the two sensors (and things like calibration etc
afterall we don't really have a ready consistent measure for infrared
in the same way as the perception scaled illuminance)

It's entirely possible that two sensors on a given device might get
different readings, both of which are useful. e.g. one of those
phones with a screen on the outside then a flip lid with another one
underneath for example. 

> 
> If no, I can't image how the userspace app uses these attributes?
That depends if your aim is to use them to control the brightness of
a screen and similar, or for example to use them for environmental
monitoring.

I agree with Jean (next email) in many ways that it is useful to
hide some complexity within a given driver (so as to provide
consistent interfaces etc to userspace.) However, if we can
also provide device specific access to other features of the device
I see no reason not to make them available.  As already stated, there
are several applications where that infrared measurement is useful
even if only available as a raw adc count. (typically you'd have a
calibration function from measured values of what ever you care about
anyway).

As long as we have illuminance (the generally useful one that all such
sensors seem to provide) then any other values the driver wants to export
are fine as long as we maintain decent documentation of what they are.

Jonathan

