Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYAJTEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYAJTEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbYAJTD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:03:58 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253AbYAJTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:03:56 -0500
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to
	unlocked_ioctl
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andre Noll <maan@systemlinux.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
In-Reply-To: <20080110185944.GA1690@one.firstfloor.org>
References: <20080110180529.GA32640@skl-net.de>
	 <1199991298.3141.75.camel@localhost.localdomain>
	 <20080110185944.GA1690@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 13:03:48 -0600
Message-Id: <1199991828.3141.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 19:59 +0100, Andi Kleen wrote:
> > Really, all this is doing is open coding what the ioctl handler is doing
> > anyway, isn't it? in which case, why bother to change it at all?
> 
> Because once it's open coded it is visible and can then be eliminated.
> Does SCSI need the BKL at all?

No, of course not ... it hasn't for ages, otherwise linux performance
would be in the tank.  If we require the BKL at all in the ioctl path it
will be to protect the non-SCSI structures we have to use.  Is there any
guide to which structures in the kernel still require the BKL?

> But perhaps for such a long ioctl handler it would be better to move
> the lock/unlock_kernel()s into the individual case ...: statements;
> then it could be eliminated step by step.

James


