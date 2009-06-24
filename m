Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbZFXSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbZFXSmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZFXSmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:42:24 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47686 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbZFXSmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:42:23 -0400
Date: Thu, 25 Jun 2009 03:41:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <gregkh@suse.de>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       hjk@linutronix.de, magnus.damm@gmail.com
Subject: Re: [PATCH 1/2] UIO: add device clock support
Message-ID: <20090624184120.GA12953@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg KH <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
	linux-kernel@vger.kernel.org, hjk@linutronix.de,
	magnus.damm@gmail.com
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de> <1245857425-25389-2-git-send-email-daniel@caiaq.de> <20090624163414.GB26409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624163414.GB26409@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:34:14AM -0700, Greg KH wrote:
> On Wed, Jun 24, 2009 at 05:30:24PM +0200, Daniel Mack wrote:
> > Add a pointer to a 'struct clk' to uio_info. Drivers can set
> > this pointer if a clock is needed, and the UIO core will care
> > to enable and disable it upon device open and release.
> 
> Do you have a UIO driver that needs this?
> 
> If so, please submit it at the same time, otherwise adding
> infrastructure for no driver that needs it, is pretty pointless.
> 
We can use this for the uio_pdrv_genirq case on sh, but open/release is a
bit coarse grained. Presently we default-enable clocks for devices that
are handled through uio, so doing it at open/release is at least better
than that. The other thing to consider is if we really want to add a
HAVE_CLK depdendency outright, or just ifdef around it..
