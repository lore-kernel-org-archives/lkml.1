Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbXK1OLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbXK1OLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbXK1OLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:11:09 -0500
Received: from rtr.ca ([76.10.145.34]:2188 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXK1OLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:11:07 -0500
Message-ID: <474D76F9.6080504@rtr.ca>
Date: Wed, 28 Nov 2007 09:11:05 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Kjartan Maraas <kmaraas@broadpark.no>, Tomas Carnecky <tom@dbservice.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain> <474D6EA7.2000506@gmail.com>
In-Reply-To: <474D6EA7.2000506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>
> Your BIOS is probably trying to issue DCO freeze lock to all drives.  I
> don't have the faintest idea why it does but it does.  I think there are
> several choices here.
> 
> 1. Ignore device errors for _GTF commands.  Report the failure with
> KERN_DEBUG priority and just keep processing.  ISTR there was a patch to
> do this.  Anyone knows what happened to it.
..

Since we now *know* that this is how it has to be done
(as otherwise the BIOS would never even attempt DCO here
because most drives don't support it yet),
then ignoring the return value seems to be a useful strategy.

> 2. Filter out certain commands from ACPI.  I definitely don't like BIOS
> locking up random features via _GTF commands.  It makes debugging difficult.
..

Mmmm.. I agree there, too!  I'm not big on filtering out commands
that *we* don't happen to like, but for this specific opcode, yes.

> 3. Look at opcode on failure and ignore error for certain operations.
..

Number 1. would take care of this.

Cheers
