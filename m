Return-Path: <linux-kernel-owner+w=401wt.eu-S1763989AbZFLLrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763989AbZFLLrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762123AbZFLLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:46:49 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:56306 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762914AbZFLLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:46:48 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core  temperature
Date: Fri, 12 Jun 2009 06:46:45 -0500
User-Agent: KMail/1.9.9
Cc: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
       Harald Welte <HaraldWelte@viatech.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090609083406.GE25316@prithivi.gnumonks.org> <20090611153255.ba8d6c54.akpm@linux-foundation.org> <20090612101200.3fe6d494@hyperion.delvare>
In-Reply-To: <20090612101200.3fe6d494@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120646.48615.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Jean Delvare wrote:
> On Thu, 11 Jun 2009 15:32:55 -0700, Andrew Morton wrote:
> > On Wed, 10 Jun 2009 17:40:31 +0000 (UTC)
> > Tomaz Mertelj <tomaz.mertelj@guest.arnes.si> wrote:
> > 
> > > Harald Welte <HaraldWelte <at> viatech.com> writes:
> > > 
> > > > 
> > > > This is a driver for the on-die digital temperature sensor of
> > > > VIA's recent CPU models.
> > > > 
> > > > Signed-off-by: Harald Welte <HaraldWelte <at> viatech.com>
> > > > 
> > > 
> > > Harald,
> > 
> > You carefully removed Harald from Cc: so he probably didn't read your
> > email.
> > 
> > > I tested it on 2.6.28.3 kernel on VIA VB7002 motherboard and it does not work 
> > > correctly.
> > > 
> > > Output form sensors:
> > > 
> > > via-cputemp-isa-0000
> 
> Harald, dashes in hwmon chip names are _prohibited_. Please change to
> via_cputemp or similar.
> 
> > > Adapter: ISA adapter
> > > Core 0:       +0.0 C
> > > 
> > > On the other hand 
> > > cat '/sys/class/hwmon/hwmon2/device/driver/via-cputemp.0/temp1_input' outputs 
> > > numbers between 25-27. 
> > > 
> 
> Temperature values are supposed to be expressed in millidegrees C, not
> degrees C as it seems to be doing (although 25 degrees C seems pretty
> low for a CPU temperature?) The drivers needs to multiply values by
> 1000 before exporting them to sysfs. Then "sensors" will report the
> correct temperature value.
> 

Ah, 25 degrees C is room temperature - real hard for the junction temperature
to be 25 degrees C with power applied; lacking an infinitely perfect heatsink.

Look for an "off by one" error in shifting or masking the value.

Mike
