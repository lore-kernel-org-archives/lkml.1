Return-Path: <linux-kernel-owner+w=401wt.eu-S938032AbXHIHUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938032AbXHIHUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXHIHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:20:41 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:54119 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753164AbXHIHUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:20:40 -0400
Date: Thu, 9 Aug 2007 09:09:15 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] bad temperature values from w83781d in 2.6.22
Message-ID: <20070809070915.GA24252@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	"Mark M. Hoffman" <mhoffman@lightlink.com>,
	LKML <linux-kernel@vger.kernel.org>,
	lm-sensors <lm-sensors@lm-sensors.org>
References: <20070805183219.0d54802b.akpm@linux-foundation.org> <20070808010316.GB3584@jupiter.solarsys.private> <20070808151716.GA6053@sommrey.de> <20070809035642.GE3584@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070809035642.GE3584@jupiter.solarsys.private>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Aug 08, 2007 at 11:56:42PM -0400, Mark M. Hoffman wrote:
> Hi Joerg:
> 
> * Joerg Sommrey <jo@sommrey.de> [2007-08-08 17:17:16 +0200]:
> > Hi Mark,
> > 
> > just to eliminate as many impacts as possible, I did:
> > - reinstall the unmodified sensors.conf from Tyan's support page
> > - power off before rebooting
> > 
> > A call to "sensors -s" is done without errors in all cases.
> > The module parameters I use currently with both kernels:
> > 
> > options w83781d force_w83782d=0,0x2d force_subclients=0,0x2d,0x48,0x49
> > options w83627hf force_addr=0x0c00
> > 
> > When I first realized the problem, I didn't use w83627hf yet.  Results
> > are the same when w83781d is used as driver for w83627hf.
> > Parameters in that case just from Tyan:
> > 
> > options w83781d force_w83782d=0,0x2d force_subclients=0,0x2d,0x48,0x49 force_w83627hf=0,0x2c force_subclients=0,0x2c,0x4a,0x4b init=0
> > 
> > "My" i2cdump doesn't accept an -y option, maybe a Debianism.  Results
> > see below.
> 
> Newer i2cdump skips the 5-second warning when given -y, that's all.
> 
> > ### 2.6.21 ###############################
> > Script started on Wed Aug  8 16:53:10 2007
> > bear:~/hwmon# i2cdump 0 0x2d b 0 0x4e
> 
> (snip tons of results)
> 
> Thanks for sending all that.  I see one bug clearly, and I'm pretty close to
> seeing the other one.  But for tonight, I need sleep.
> 
> In the meantime, please try this command as root, against the newer kernel,
> *after* you've done 'sensors -s':
> 
> 	# i2cset -f 0 0x2d 0x5d 0x0e b
> 
> Wait > 2 seconds for the hardware to update itself, then run 'sensors' again.
> I'm pretty sure you'll see the correct temps.
The displayed temperatures changed to 67.5°C / 66.0°C.  Still, this seems to
be too high.  The power supply's fan runs too slow for such CPU
temperatures. In older kernels it becomes noisy above 50°C.

Under load the temperatures shown are around 95°C, way too high.

-jo

-- 
-rw-r--r-- 1 jo users 62 2007-08-08 21:06 /home/jo/.signature
