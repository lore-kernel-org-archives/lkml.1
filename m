Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZHTHkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZHTHkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHTHka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:40:30 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:64655 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbZHTHka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:40:30 -0400
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090819181426.GA12827@kroah.com>
References: <1250665599.4545.3.camel@localhost>
	 <20090819154437.GA729@kroah.com> <1250698851.4323.9.camel@localhost>
	 <20090819163439.GA3094@kroah.com> <1250703549.4323.16.camel@localhost>
	 <20090819181426.GA12827@kroah.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 08:40:27 +0100
Message-Id: <1250754027.4820.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=77gSv6d_8poA:10 a=V-Okoctr_DPSXwGDZu8A:9 a=QlV3DTe79CkZid8Q1OYA:7 a=rguFkRKBX7ELuBdYnvcKLf21Z_4A:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 11:14 -0700, Greg KH wrote:
> On Wed, Aug 19, 2009 at 06:39:09PM +0100, Karl Relton wrote:
> > On Wed, 2009-08-19 at 09:34 -0700, Greg KH wrote:
> > > On Wed, Aug 19, 2009 at 05:20:51PM +0100, Karl Relton wrote:
> > > > I plan to give the various distributions a utility to pre-compile the
> > > > firmware. It is based on ihex2fw.c.
> > > > 
> > > > I don't think the firmware will ever be accepted into linux-firmware
> > > > because the original licensing cannot be established.
> > > 
> > > Have you asked the company?
> > > Where is the firmware at today?
> > > 
> > 
> > At some point in the past the owner was Conexant, but we are not sure
> > they still own in. Some efforts to track down which company now owns
> > this firmware, and who the contact within that company would be, have
> > been made but have not been successful.
> > 
> > The firmware is downloadable from the linux-wlan-ng project. I have been
> > liasing with the maintainer in that project, who has tried to help as
> > far as he could.
> 
> Ok, I'm just worried that if I take this change, then users whose
> systems were working, will now break.  So, why would this change
> actually help anyone out?
> 
I think the change will negatively effect very few users to be honest -
since driver firmware loading was only introduced in .31 anyway. I doubt
if any distributions have arranged to install the srec firmware file
in /lib/firmware to coincide with the .31 kernel release. Currently
users (and distributions) use the old user-space utility that squirts
the firmware at the driver via an ioctl, and I'm sure it will stay that
way for users in the near future.

Once we have binary fw loading heading for mainline, I will start
working with distributions so that if they have scripts/packages to make
the firmware available, they should use the new pre-compiler and put the
result in /lib/firmware, to align with the .32 kernel.

The eventual advantage is a lighter weight firmware file (one third the
size), and slightly quicker runtime processing and hence faster startup
time (e.g. system boot). Thats the reasoning people gave me when they
heard the driver was doing srec loading.

Cheers
Karl

