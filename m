Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYGWQuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYGWQuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYGWQu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:50:29 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:20442 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751797AbYGWQu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:50:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1/NQGnXsIIKOSzuK/gWYZZwimyrTat49FEV93h6cXhT9Yl2Tjgpq9KxkLSenuezJAXcRRcUGMgch+q5wQzMsvOk3fz4BkYFNtmrv0VihMUhgEX7cDe15wdVpvxKv8SI335DA1W7w8R6nrzv/hhzQufzCtSj/sUQJ9HsclEUWYtA=  ;
X-YMail-OSG: aGBzo68VM1lvQKPrdq1ul8hYqx35DQZ25069Yx0hstyTUBVI8vNzxwxQpFvI3n7eo1df.584dniOgKOD_eNkgAtZTn.F55KU4jn60D593_qe5Dv3pbgJsSC7NwSiH906unI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
Date: Wed, 23 Jul 2008 09:50:25 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <4886E164.2070304@ladisch.de> <200807230912.49850.david-b@pacbell.net>
In-Reply-To: <200807230912.49850.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807230950.26160.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, David Brownell wrote:
> On Wednesday 23 July 2008, Clemens Ladisch wrote:
> > David Brownell wrote:
> > >   * Tighten and correct the userspace interface code
> > >       ...
> > >       + only open comparators that have an interrupt, and can thus
> > >         perform "real work"
> > 
> > This prevents userspace applications from doing mmap() on /dev/hpet
> > even if there is no interrupt.
> 
> OK, I removed that ... HPET_IE_ON will already fail.

This change will be included in the next version of this patch, which
I'll send after other responses get more of a chance to trickle in.
(That line already changed because of the hd_task elimination.)

--- g26.orig/drivers/char/hpet.c	2008-07-23 09:43:59.000000000 -0700
+++ g26/drivers/char/hpet.c	2008-07-23 09:03:34.000000000 -0700
@@ -189,8 +189,7 @@ static int hpet_open(struct inode *inode
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
-			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN
-					|| !hpetp->hp_dev[i].hd_hdwirq)
+			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
 				continue;
 			else {
 				devp = &hpetp->hp_dev[i];
