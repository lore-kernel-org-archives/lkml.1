Return-Path: <linux-kernel-owner+w=401wt.eu-S935389AbYCFQbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935389AbYCFQbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935280AbYCFQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:30:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935088AbYCFQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:30:40 -0500
Date: Thu, 6 Mar 2008 08:30:32 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: Behaviour of device_register
Message-ID: <20080306163032.GA12982@kroah.com>
References: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com> <20080305234653.GA5904@kroah.com> <8031.85.118.17.158.1204806681.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8031.85.118.17.158.1204806681.squirrel@newgolddream.dyndns.info>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:31:21PM -0000, Adrian McMenamin wrote:
> On Wed, March 5, 2008 11:46 pm, Greg KH wrote:
> > On Wed, Mar 05, 2008 at 11:25:48PM +0000, Adrian McMenamin wrote:
> >> The observed behaviour for me is that it appears to be blocking the
> >> vblank interrupt on my box (or more accurately stopping the workqueue
> >> that the interrupt handler calls from running). And without the vblank
> >> my bus won't process dma and so therefore the attempt to register the
> >> device in question fails.
> >>
> >> But I can see no reason from a glance over the code why that (vblanks
> >> being blocked) would be the case - have I missed something and the
> >> vblanks will be blocked, or should I be looking elsewhere for the root
> >> cause of this problem?
> >
> > device_register(), on it's own, does not touch any hardware, nor prevent
> > anything else in the kernel from happening.
> >
> > So I think you need to look elsewhere, like into the bus that is doing
> > the device_register() call :)
> >
> 
> 
> It turns out this is a lock contention issue.
> 
> The code blocks waiting for a lock that will never be freed.

The device_register() code blocks?  Or something else?
