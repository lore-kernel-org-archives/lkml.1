Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYAJTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYAJTaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYAJT3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:29:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40146 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYAJT3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:29:50 -0500
Date: Thu, 10 Jan 2008 20:32:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andre Noll <maan@systemlinux.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Message-ID: <20080110193227.GH747@one.firstfloor.org>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <1199991828.3141.82.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199991828.3141.82.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 01:03:48PM -0600, James Bottomley wrote:
> 
> On Thu, 2008-01-10 at 19:59 +0100, Andi Kleen wrote:
> > > Really, all this is doing is open coding what the ioctl handler is doing
> > > anyway, isn't it? in which case, why bother to change it at all?
> > 
> > Because once it's open coded it is visible and can then be eliminated.
> > Does SCSI need the BKL at all?
> 
> No, of course not ... it hasn't for ages, otherwise linux performance
> would be in the tank.  If we require the BKL at all in the ioctl path it
> will be to protect the non-SCSI structures we have to use.  Is there any
> guide to which structures in the kernel still require the BKL?

Not many really in the core kernel. Hardly any. Grep for 
lock_kernel to be sure, but there is not much.

It's mostly drivers that still need it.

How about the low level SCSI drivers that might called from the high
level SCSI code? 

Anyways starting these kinds of discussions was the goal of the proposal.
Even if Andre's patch ends up not being merged it would have reached
its goal.

-Andi 

