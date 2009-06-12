Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFLPMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFLPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZFLPMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:12:37 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:34470 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZFLPMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:12:37 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: tomaz.mertelj@guest.arnes.si
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core	temperature
Date: Fri, 12 Jun 2009 10:12:34 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090612_144621_045117.tomaz.mertelj@guest.arnes.si> <200906120957.27223.lkml@morethan.org>
In-Reply-To: <200906120957.27223.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121012.36832.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Michael S. Zick wrote:
> On Fri June 12 2009, tomaz.mertelj@guest.arnes.si wrote:
> > > > 
> > > > Ah, 25 degrees C is room temperature - real hard for the junction 
> > temperature
> > > > to be 25 degrees C with power applied; lacking an infinitely perfect 
> > heatsink.
> > > > 
> > > > Look for an "off by one" error in shifting or masking the value.
> > > 
> > > there is no shifting and the masking is 0xffffffff :)
> > > 
> > > it might be that the BIOS is doing something wrong when programming the
> > > calibration MSR's at early botoup.  I would need the contents of MSR 
> > > 0x1160 ... 0x116C as well as 0x1152 and 0x1153 to be able to determine 
> > that.
> > > 
> > 
> > This is what I get on VB7002.. vith C7-D cpu:
> > 
> > 
> > DEBNAS:/home# sensors
> > 
> > via-cputemp-isa-0000
> > Adapter: ISA adapter
> > Core 0:      +27.0 C 
> > 
> > DEBNAS:/home# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 
> > 0x1167
> > 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do ./rdmsr $r ; done
> > MSR register 0x1160 => 08:04:98:10:b8:0b:6f:f4
> > MSR register 0x1161 => 08:04:98:10:b8:0a:8f:f4
> > MSR register 0x1162 => 08:04:98:10:b7:f7:7f:f4
> > MSR register 0x1163 => 08:04:98:10:b7:f1:1f:f4
> > MSR register 0x1164 => 08:04:98:10:b7:ee:cf:f4
> > MSR register 0x1165 => 08:04:98:10:b8:0b:4f:f4
> > MSR register 0x1166 => 08:04:98:10:b7:f7:7f:f4
> > MSR register 0x1167 => 08:04:98:10:b7:ef:8f:f4
> > MSR register 0x1168 => 08:04:98:10:b7:fc:3f:f4
> > MSR register 0x1169 => 08:04:98:10:b8:0d:6f:f4
> > MSR register 0x116a => 08:04:98:10:b7:f3:8f:f4
> > MSR register 0x116b => 08:04:98:10:b8:0b:bf:f4
> > MSR register 0x116c => 08:04:98:10:b8:00:6f:f4
> > MSR register 0x1152 => 08:04:98:10:b7:f2:2f:f4
> > MSR register 0x1153 => 08:04:98:10:b8:0b:3f:f4
> > DEBNAS:/home#
> > 
> >
> 
> The author had a problem in that routine -
> try this one (32bit machines only) -
> 

That tool has more than one problem -
Try installing your distro's msr-tools package instead.

Mike
> Mike 
> > Tomaz Mertelj
> > 
> > 
> > 
> 
> 
> 


