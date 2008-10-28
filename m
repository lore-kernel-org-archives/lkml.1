Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYJ1MCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYJ1MCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYJ1MCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:02:43 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56449 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYJ1MCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:02:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18694.65280.371472.203936@harpo.it.uu.se>
Date: Tue, 28 Oct 2008 13:01:04 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <tj@kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 2.6.28-rc2] sata_promise: proper hardreset
In-Reply-To: <490673AB.2090502@kernel.org>
References: <200810270049.m9R0ngI8027933@harpo.it.uu.se>
	<490673AB.2090502@kernel.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > Hello, Mikael.
 > 
 > Mikael Pettersson wrote:
 > > +static int pdc_pata_hardreset(struct ata_link *link, unsigned int *class,
 > > +			      unsigned long deadline)
 > > +{
 > > +	pdc_reset_port(link->ap);
 > > +	return 0;
 > > +}
 > 
 > You either need to return -EAGAIN here to ask for follow-up SRST or
 > override softreset.  I think pdc_reset_port() doesn't actually reset the
 > ATA channel, right?  In that case, the latter would be the correct thing
 > to do.

(ponders..) ah yes, pata normally skips hardreset so this would
make it skip the needed softreset. pdc_reset_port() just reinits
the ATA engine, nothing else should be affected.

I'll update the patch to make pata override ->softreset instead.

Thanks.

/Mikael
