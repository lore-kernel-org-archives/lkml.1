Return-Path: <linux-kernel-owner+w=401wt.eu-S933680AbZJHVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbZJHVST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933524AbZJHVSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:18:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44316 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932881AbZJHVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:18:17 -0400
Date: Thu, 8 Oct 2009 22:19:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Message-ID: <20091008221901.2321cca6@lxorguk.ukuu.org.uk>
In-Reply-To: <200910082240.36607.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0910081601350.2765-100000@iolanthe.rowland.org>
	<200910082240.36607.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 22:40:36 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag, 8. Oktober 2009 22:06:10 schrieb Alan Stern:
> 
> >
> > On further thought, unthrottle should autoresume if the device is
> > open and autosuspended (but it shouldn't do anything if the device is
> > suspended).  After all, the reason for the autosuspend may have been
> > the lack of activity caused by the throttling.
> >
> > In practice this isn't likely to come up.  It would be surprising if
> > throttling lasted long enough to cause an autosuspend or if the core
> > decided to throttle while the device was autosuspended and hence idle.
> 
> So you say that throttle() should do an autopm_put?

You need to be very very sure you cannot lose a byte of data or have the
modem lines disrupted in any way if you do that.
