Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbZFLNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbZFLNGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763158AbZFLNAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:00:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42576 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763150AbZFLNAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:00:12 -0400
Date: Fri, 12 Jun 2009 20:54:50 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core
	temperature
Message-ID: <20090612125450.GK30843@prithivi.gnumonks.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org> <20090611153255.ba8d6c54.akpm@linux-foundation.org> <20090612101200.3fe6d494@hyperion.delvare> <200906120646.48615.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906120646.48615.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:46:45AM -0500, Michael S. Zick wrote:
> > Temperature values are supposed to be expressed in millidegrees C, not
> > degrees C as it seems to be doing (although 25 degrees C seems pretty
> > low for a CPU temperature?) The drivers needs to multiply values by
> > 1000 before exporting them to sysfs. Then "sensors" will report the
> > correct temperature value.
> > 
> 
> Ah, 25 degrees C is room temperature - real hard for the junction temperature
> to be 25 degrees C with power applied; lacking an infinitely perfect heatsink.
> 
> Look for an "off by one" error in shifting or masking the value.

there is no shifting and the masking is 0xffffffff :)

it might be that the BIOS is doing something wrong when programming the
calibration MSR's at early botoup.  I would need the contents of MSR 
0x1160 ... 0x116C as well as 0x1152 and 0x1153 to be able to determine that.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
