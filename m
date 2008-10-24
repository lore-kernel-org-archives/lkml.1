Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYJXTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYJXTol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYJXToe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:44:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4665 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYJXTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:44:33 -0400
Date: Fri, 24 Oct 2008 20:44:16 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Liam Girdwood <lrg@kernel.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>
Message-ID: <20081024194415.GB6621@sirena.org.uk>
References: <4901EE0F.5000508@cam.ac.uk> <490204A3.6010505@gmail.com> <1224872665.28382.73.camel@dell-desktop.example.com> <490219B1.6010502@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490219B1.6010502@cam.ac.uk>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Da903x regulator driver. Bug?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 07:53:37PM +0100, Jonathan Cameron wrote:

> >> is 2 layers down rather than one requiring quite a few changes
> >> to   
> >>  struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
> >> from
> >>     struct device *da9034_dev = rdev_get_dev(rdev)->parent;

> >> So either a change to the regulator framework is needed to
> >> allow mfd's or these extra ->parent lines need to go in in lots
> >> of places.

> >> Which do people prefer?

> > Could you fix in a similar method to the wm8350/wm8400. 

> Based on a quick look, I think this involves carrying around
> an additional copy of the device pointer inside the driver data.

> If so that would indeed work.

Yes, I'm actively using these.  I had been considering going back and
removing the extra layer of platform device from the code for WM8350 and
WM8400 since there is now less benefit to it but I would probably still
continue to use the driver_data to store the pointer to the wm8350 data
since I find that gives clear code.

The current situation was a minimal adaption to avoid churn in the core
API close to release - previously the regulator had been forced to be a
platform device but this was changed since we have to allocate a new
device when registering the regulator in order to have the class work in
sysfs.
