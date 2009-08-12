Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZHLLMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZHLLMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554AbZHLLMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:12:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZHLLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:12:06 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2009 13:11:34 +0200
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-hotplug@vger.kernel.org
References: <200908111830.03224.jbe@pengutronix.de> <20090812074753.GL13320@pengutronix.de> <20090812092034.GA19269@csn.ul.ie>
In-Reply-To: <20090812092034.GA19269@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908121311.35321.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD is set" fails on my system
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 12. August 2009, Mel Gorman wrote:
> > > I get the following Ooops message when "udevadm" is running on an ARM
> > > S3C2440 CPU based system:
>
> This is extremely odd. All that patch is doing is changing what order pages
> are returned in to the caller when __GFP_COLD is specified.  valid memory.
> Does reverting the patch really make the problem go away?

At least I can work with the system if I remove this patch. Theres is no oops, 
so udev creates all the required devnodes and the system comes up into the 
login prompt.

> > > [...]
> > > starting udevd...done
> > > Unable to handle kernel paging request at virtual address e3540000
> > > pgd = c39d4000
> > > [e3540000] *pgd=00000000
> > > Internal error: Oops: 5 [#1]
> > > Modules linked in:
> > > CPU: 0    Not tainted  (2.6.31-rc4-00296-ge084b2d-dirty #10)
> > > PC is at strlen+0xc/0x20
> > > LR is at kobject_get_path+0x24/0xa4
>
> I haven't tackled this sort of bug before but it looks more likely that
> there is garbage in the sysfs tree that is being tripped up on.

Yes, I think so, too. Because the same binary rc5 image runs on an S3C2410 CPU 
without an oops, but oopses on an S3C2440 (both CPUs are nearly the same, but 
only nearly). But how to track down such a failure?

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
