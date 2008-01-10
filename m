Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYAJSz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYAJSz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYAJSzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:55:12 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43454 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYAJSzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:10 -0500
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to
	unlocked_ioctl
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andre Noll <maan@systemlinux.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
In-Reply-To: <20080110180529.GA32640@skl-net.de>
References: <20080110180529.GA32640@skl-net.de>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:54:58 -0600
Message-Id: <1199991298.3141.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 19:05 +0100, Andre Noll wrote:
> [Resent with proper subject and to additional recipients]
> 
> This patch against linus-current is compile-tested on x86 and x86-64.
> 
> Please review

This is rather long.  For the utility of what you've just done, what's
wrong with just making the .unlocked_ioctl point to sg_unlocked_ioctl()
and doing:

sg_unlocked_ioctl()
	int rc;

	lock_kernel();
	rc = sg_ioctl();
	unlock_kernel();

	return rc;
}

Really, all this is doing is open coding what the ioctl handler is doing
anyway, isn't it? in which case, why bother to change it at all?

James


