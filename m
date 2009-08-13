Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZHMJWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZHMJWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZHMJWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:22:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58574 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbZHMJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:22:53 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: ben-linux@fluff.org
Date: Thu, 13 Aug 2009 11:22:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Arnaud Faucher <arnaud.faucher@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-hotplug@vger.kernel.org
References: <200908111830.03224.jbe@pengutronix.de> <1250102430.4912.4.camel@green> <20090813083910.GA27006@csn.ul.ie>
In-Reply-To: <20090813083910.GA27006@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908131122.40423.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD is set" fails on my system
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 13. August 2009, Mel Gorman wrote:
> On Wed, Aug 12, 2009 at 02:40:30PM -0400, Arnaud Faucher wrote:
> > I have a rather similar problem on a driver that I try to keep
> > up-to-date with recent kernel versions
> > (http://code.ximeta.com/trac-ndas/ticket/1110#comment:30). The NDAS
> > hardware is an ethernet-enabled disk controller on one chip, kind of a
> > cheap iSCSI.
> >
> > In my case there is no oops: the symptoms are that the read blocks seem
> > to be swapped or full of garbage.
> >
> > After investigation in the NDAS code, the bug triggers when the driver
> > tries to merge adjacent requests before sending them to the controller.
> > I had to disable this merge in order to restore normal behavior, at the
> > expense of a reduced efficiency.
>
> That is a very interesting point and one I hadn't considered. The point
> of the patch was to help drivers that merge adjacent requests if they
> happen to be physically contiguous. The reported bug that led to the
> patch was a regression of memory not being physically contiguous and
> requests not being merged.
>
> > > After this oops, system startup continues. Then the next oops occurs:
> > >
> > > This one is new, since I try to mount the connected SD card.
> >
> > Mel's buffer overrun theory seems to apply in the NDAS driver case,
> > where the original requests adjacency test seems faulty.
> >
> > May it also be the cause of the SD mounting crash ?
>
> It's a possibility. If it's not an overrun, it's possible that the
> automatic merging code is buggy as well.
>
> Juergen, is the disk controller on your machine capable of merging
> requests? If so, can you disable it and see if the bug still occurs
> please?

Hmmm, hard to say. Maybe the author of this driver can say more.

@Ben: MMC/SD/SDHC driver for the s3c2440-CPU. Can you answer Mel's question? 

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
