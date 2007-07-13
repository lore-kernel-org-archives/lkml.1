Return-Path: <linux-kernel-owner+w=401wt.eu-S937396AbXGMXHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937396AbXGMXHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbXGMXGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:06:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:36932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759749AbXGMXGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:06:54 -0400
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1184331741.3402.13.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	 <20070704132346.591348000@pademelon.sonytel.be>
	 <1184331741.3402.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 09:06:10 +1000
Message-Id: <1184367971.6059.268.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 09:02 -0400, James Bottomley wrote:
> On Wed, 2007-07-04 at 15:22 +0200, Geert Uytterhoeven wrote:
> > +                       kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > +                       if (!kaddr)
> > +                               return -1;
> > +                       len = sgpnt->length;
> > +                       if ((req_len + len) > buflen) {
> > +                               active = 0;
> > +                               len = buflen - req_len;
> > +                       }
> > +                       memcpy(kaddr + sgpnt->offset, buf + req_len,
> > len);
> > +                       kunmap_atomic(kaddr, KM_USER0);
> 
> This isn't a SCSI objection, but this sequence appears several times in
> this driver.  It's wrong for a non-PIPT architecture (and I believe the
> PS3 is VIPT) because you copy into the kernel alias for the page, which
> dirties the line in the cache of that alias (the user alias cache line
> was already invalidated).  However, unless you flush the kernel alias to
> main memory, the user could read stale data.  The way this is supposed
> to be done is to do a 

Nah, we have no cache aliasing on ppc, at least not that matter here and
not on cell.

Ben.

