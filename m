Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYHZRpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYHZRpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbYHZRph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:45:37 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:34371 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757273AbYHZRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:45:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X0P1T06nLsrD0is/XVgf9jGjUKPtRwT5AppIu5qoNijHDSjFsr0Kt8eGTvS4FZbkFvRUwtMTHVhfiNf7jnUNUm5WAGj9GiJOMzf3Ssv22OWxEjTMAZ6rTWfelL317KQY6FaWDftg6FR6EvZ6jUCdjX3AoccCU7hEEFpjrMjYdpo=  ;
X-YMail-OSG: HWgry2oVM1mswubyToQzF3I9O1cQasAtr2wPhdOGP4tOkzAVRAMKkEwB20QqbzeWc.Ols.156LGI1hyPlCNwVZPUgnUuCHm1_dOaTyT.Jg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Date: Tue, 26 Aug 2008 10:45:34 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Alex Williamson <alex.williamson@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261045.34699.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, how serious is the problem which is being fixed here?  It
> > _sounds_ like it's of the "fatal for people who have that hardware"
> > variety, in which case we should get this into 2.6.27 and probably
> > 2.6.26.x.  Not sure about 2.5.26.x though - the patch doesn't apply
> > there, but I didn't check whether this is due to functional changes.
>
> For users of this version of this particular UART IP it is fatal. From
> looking at the git history it looks like the original patch went into
> 2.6.26 so it might also affect that kernel.

Second that:  serial-8250-tighten-test-for-using-backup-timer.patch
(from MMOTM) in mainline sooner-not-later seems right.

My own exposure to this is that the UART on DaVinci hardware, which
TI allegedly derived from its original 16550 logic, has periodically
gone from working to unusable with the mainline 8250.c ... and back
and forth a bunch.  Currently it's "unusable", a regression from some
previous versions.  With this patch from Alex, it's usable.

Of course there are a bunch of arch/arm/mach-davinci patches needed
to make that platform more functional in mainline.  I expect they'll
probably merge in the 2.6.28-rc0 window.  Meanwhile, running out of
ramdisk with a serial console should at least work right!  :)

- Dave
