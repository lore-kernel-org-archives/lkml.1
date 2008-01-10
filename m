Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYAJUJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYAJUJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYAJUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:09:40 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45248 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbYAJUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:09:38 -0500
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to
	unlocked_ioctl
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andre Noll <maan@systemlinux.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
In-Reply-To: <20080110194550.GB20152@skl-net.de>
References: <20080110180529.GA32640@skl-net.de>
	 <1199991298.3141.75.camel@localhost.localdomain>
	 <20080110185944.GA1690@one.firstfloor.org>
	 <20080110190748.GA20152@skl-net.de>
	 <20080110192950.GG747@one.firstfloor.org>
	 <20080110194550.GB20152@skl-net.de>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 14:09:32 -0600
Message-Id: <1199995772.3141.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 20:45 +0100, Andre Noll wrote:
> On 20:29, Andi Kleen wrote:
> 
> > > Sure, I can do that if James likes the idea. Since not all case
> > > statements need the BKL, we could add it only to those for which it
> > > isn't clear that it is unnecessary.
> > > 
> > > And this would actually improve something.
> > 
> > I still think it would be a good strategy to first add it to all
> > (in a essentially nop semantics patch) and then later eliminate
> > it from the cases that obviously don't need it. 
> 
> James, would you accept such a patch?

Our current suspicion is that none of the SCSI ioctl paths require the
BKL.  Al Viro said he'd try to look into this, so currently I think the
conversion path is just to move .ioctl -> .unlocked_ioctl

However, more eyes on the problem would be most welcome.

James


