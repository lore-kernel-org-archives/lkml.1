Return-Path: <linux-kernel-owner+w=401wt.eu-S1764710AbZAOSgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764710AbZAOSgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZAOSgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:36:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3168 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZAOSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:36:21 -0500
Date: Thu, 15 Jan 2009 18:36:14 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within mfd driver.
Message-ID: <20090115183613.GE12768@sirena.org.uk>
References: <496E2BE5.1050803@cam.ac.uk> <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com> <496ED8F6.6030201@compulab.co.il> <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com> <496EE5A4.4010805@compulab.co.il> <f17812d70901150013v2c70047er829b1c884a1d7772@mail.gmail.com> <496F1C7A.5080202@gmail.com> <20090115130230.GG2147@sirena.org.uk> <496F3ABF.1020201@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F3ABF.1020201@cam.ac.uk>
X-Cookie: I will not forget you.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 01:31:43PM +0000, Jonathan Cameron wrote:
> Mark Brown wrote:

> > Having looked at this problem just this week for some other designs I'm
> > thinking the regulator API might be a good fit for this.  It is a supply
> > and the API provides a method to match up the supply with the USB
> > controller (some designs have multiple options there so that's useful).
> > I've not actually tried it yet to see what the pain is like, though.

> I did at one point.  The problem here is you aren't simply controlling the
> current / voltage. You are switching it between various automatic modes
> and a manual override.  Only in the manually overridden states is it
> much like a regulator and then it's one with very odd properties.

Yes, they're rather different and would require additional APIs for
controlling some of the features, though it may be that we can get away
with doing a lot of the configuration in platform data or board init
code with a more limited subset configured dynamically by the USB stack.

> If these are consistent enough across different pmic's I guess it could
> be blugeoned in, but I'm not convinced this is true.

Yes, that needs to be investigated.  I'd hope there's *some* similarity
since at the end of the day it's all USB but I've not got to the point
of looking at that yet.
