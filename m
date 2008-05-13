Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYEMP4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYEMP4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYEMP4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:56:22 -0400
Received: from cnc.isely.net ([64.81.146.143]:50491 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYEMP4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:56:22 -0400
Date: Tue, 13 May 2008 10:56:20 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Michael Krufky <mkrufky@linuxtv.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
In-Reply-To: <20080513124630.111c465b@gaivota>
Message-ID: <Pine.LNX.4.64.0805131050210.20885@cnc.isely.net>
References: <20080511072137.GA16772@elte.hu> <37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
 <20080512235445.3a56cea0@gaivota> <37219a840805122103u2a74b050h95c006f99ff8690f@mail.gmail.com>
 <20080513124630.111c465b@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008, Mauro Carvalho Chehab wrote:

> On Tue, 13 May 2008 00:03:02 -0400
> "Michael Krufky" <mkrufky@linuxtv.org> wrote:
> 
> > 
> > That sounds like it would be OK, although something like this would
> > probably be better:
> > 
> >  config VIDEO_PVRUSB2
> >        tristate "Hauppauge WinTV-PVR USB2 support"
> > -       depends on VIDEO_V4L2 && I2C
> > +       depends on VIDEO_V4L2 && I2C && (DVB_CORE if VIDEO_PVRUSB2_DVB)
> >        select FW_LOADER
> >        select MEDIA_TUNER
> >        select VIDEO_TVEEPROM
> 
> This doesn't look to be a good idea, since VIDEO_PVRUSB2_DVB depends on
> VIDEO_PVRUSB2. So, you'll create a circular dependency. The syntax I've
> proposed seems cleaner. Of course, it needs to be tested. IMO, all hybrid
> devices should be dependent of VIDEO_MEDIA. This will help to avoid this kind
> of issue.
> 
> > I don't know if that syntax works for "depends on" , but it does work
> > for select.
> > 
> > if "depends on FOO if BAR" doesnt work, would adding "select DVB_CORE
> > if VIDEO_PVRUSB2_DVB" solve the problem?
> 
> Also, this leads into a circular reference.

Mauro:

Where is the loop that results in a circular reference?  No part of V4L 
or DVB depends (or otherwise has any reliance) on VIDEO_PVRUSB2.  All 
Mike Krufky is trying to set up is that VIDEO_PVRUSB2 should only depend 
on DVB_CORE if the DVB part of the driver (i.e. VIDEO_PVRUSB2_DVB) has 
been enabled.  Without VIDEO_PVRUSB2_DVB selected, then DVB_CORE is not 
required by the driver.

I've been quiet about this issue because I'm not a kconfig expert, but 
you've lost me with this conclusion.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
