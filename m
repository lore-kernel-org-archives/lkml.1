Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbYAJS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbYAJS5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYAJS5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:57:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54258 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbYAJS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:57:07 -0500
Date: Thu, 10 Jan 2008 19:59:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andre Noll <maan@systemlinux.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Message-ID: <20080110185944.GA1690@one.firstfloor.org>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199991298.3141.75.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Really, all this is doing is open coding what the ioctl handler is doing
> anyway, isn't it? in which case, why bother to change it at all?

Because once it's open coded it is visible and can then be eliminated.
Does SCSI need the BKL at all?

But perhaps for such a long ioctl handler it would be better to move
the lock/unlock_kernel()s into the individual case ...: statements;
then it could be eliminated step by step.

-Andi
