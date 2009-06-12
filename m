Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZFLNJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZFLNJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZFLNJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:09:10 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:52236 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFLNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:09:09 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core temperature
Date: Fri, 12 Jun 2009 08:09:05 -0500
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>,
       Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090609083406.GE25316@prithivi.gnumonks.org> <200906120646.48615.lkml@morethan.org> <20090612125450.GK30843@prithivi.gnumonks.org>
In-Reply-To: <20090612125450.GK30843@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120809.07678.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Harald Welte wrote:
> On Fri, Jun 12, 2009 at 06:46:45AM -0500, Michael S. Zick wrote:
> > > Temperature values are supposed to be expressed in millidegrees C, not
> > > degrees C as it seems to be doing (although 25 degrees C seems pretty
> > > low for a CPU temperature?) The drivers needs to multiply values by
> > > 1000 before exporting them to sysfs. Then "sensors" will report the
> > > correct temperature value.
> > > 
> > 
> > Ah, 25 degrees C is room temperature - real hard for the junction temperature
> > to be 25 degrees C with power applied; lacking an infinitely perfect heatsink.
> > 
> > Look for an "off by one" error in shifting or masking the value.
> 
> there is no shifting and the masking is 0xffffffff :)
> 
> it might be that the BIOS is doing something wrong when programming the
> calibration MSR's at early botoup.  I would need the contents of MSR 
> 0x1160 ... 0x116C as well as 0x1152 and 0x1153 to be able to determine that.
> 

I was commenting on someone else's observation - -
Will build with your patch and poke at it a bit.

I should be able to read those registers from /dev/cpu/0/msr, correct?
Or is there a "safe" mask in the msr driver that prevents reading random
MSR registers?

Mike
