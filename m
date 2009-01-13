Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZAMIIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZAMIIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZAMIIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:08:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56704 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZAMIIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:08:30 -0500
Date: Tue, 13 Jan 2009 07:42:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: platform_driver's probe functions must not be located in
	.init.text
Message-ID: <20090113064244.GA23381@pengutronix.de>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <20090113031554.GA3671@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113031554.GA3671@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:15:55PM +0900, Paul Mundt wrote:
> On Mon, Jan 12, 2009 at 11:12:02PM +0100, Uwe Kleine-K?nig wrote:
> > Hello,
> > 
> > if the probe function of a platform_driver lives in .init.text (i.e. is
> > defined using __init) registering a device after the .init sections are
> > discarded results in an oops.  You can test that by doing
> > 
> > 	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/unbind
> > 	echo $drivername.$somevalidid > /sys/bus/platform/drivers/$drivername/bind
> > 
> > As a reply to this mail I send 62 patches that fix this kind of error by
> > moving the respective probe functions to .devinit.text.
> > 
> None of these patches balance with __devexit, is that intentional?
For now, yes, it is.  

One reason is that my script to find errors doesn't trigger for that.

Another is that this is not that critical.  If the probe function is in
.init.text you can get an oops.  If remove is in .text it just occupies
RAM without being used (if HOTPLUG=n).  And if remove is in .exit.text
and is properly wrapped in __exit_p when assigning .remove everything is
fine, too, you just cannot remove a device.

Maybe I will address this in later series.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
