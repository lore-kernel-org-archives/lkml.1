Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYF2WMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYF2WMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYF2WMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 18:12:21 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:50338 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbYF2WMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 18:12:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,724,1204464600"; 
   d="scan'208";a="145965177"
Date: Mon, 30 Jun 2008 08:12:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs-masters@oss.sgi.com
Cc: Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080629221217.GM29319@disturbed>
Mail-Followup-To: xfs-masters@oss.sgi.com,
	Elias Oltmanns <eo@nebensachen.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <20080623071601.GA1553@elf.ucw.cz> <20080623140012.GA11899@khazad-dum.debian.net> <87od5rs1am.fsf@denkblock.local> <20080626150910.GK5642@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626150910.GK5642@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:09:10PM +0200, Pavel Machek wrote:
> > > Is this the same thing the per-device IO-queue-freeze patches for
> > >HDAPS also
> > > need to do?  If so, you may want to talk to Elias Oltmanns
> > > <eo@nebensachen.de> about it.  Added to CC.
> > 
> > Thanks for the heads up Henrique. Even though these issues seem to be
> > related up to a certain degree, there probably are some important
> > differences. When suspending a system, the emphasis is on leaving the
> > system in a consistent state (think of journalled file systems), whereas
> > disk shock protection is mainly concerned with stopping I/O as soon as
> > possible. As yet, I cannot possibly say to what extend these two
> > concepts can be reconciled in the sense of sharing some common code.
> 
> Actually, I believe requirements are same.
> 
> 'don't do i/o in dangerous period'.
> 
> swsusp will just do sync() before entering dangerous period. That
> provides consistent-enough state...

As I've said many times before - if the requirement is "don't do
I/O" then you have to freeze the filesystem. In no way does 'sync'
prevent filesystems from doing I/O.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
