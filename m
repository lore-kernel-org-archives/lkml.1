Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXBVRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXBVRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXBVRdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:33:11 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:59550
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXBVRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:33:11 -0500
Message-ID: <45DDD395.1050502@microgate.com>
Date: Thu, 22 Feb 2007 11:32:05 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DDB096.2020807@inov.pt> <20070222170354.GB633@flint.arm.linux.org.uk>
In-Reply-To: <20070222170354.GB633@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 03:02:46PM +0000, Jose Goncalves wrote:
> What I find real hard to understand is why a hardware fault happens
> always in the same software instruction! I would expect a hardware fault
> to hit randomly...

I've experienced just such a hardware fault.

The Infineon DSCC4 serial controller has a hardware bug
in the PCI request/grant handling that can lead to the
device driving the PCI bus in conflict with another device.

While the results were random (as the oops in this problem
seem to be), the trigger was always activating certain
devices in combination.

In your case, altering the timing/behavior of the serial
device during open may be provoking the hardware fault.

-- 
Paul Fulghum
Microgate Systems, Ltd.
