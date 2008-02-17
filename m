Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYBQRaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYBQRaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYBQRaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:30:10 -0500
Received: from mail.queued.net ([207.210.101.209]:2831 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYBQRaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:30:08 -0500
Date: Sun, 17 Feb 2008 12:32:18 -0500
From: Andres Salomon <dilinger@queued.net>
To: Iain Paton <ilp@lkml.darkvoyage.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>,
       Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
Message-ID: <20080217123218.19bbeaf3@ephemeral>
In-Reply-To: <47B85C61.7060507@lkml.darkvoyage.org.uk>
References: <20080117211917.GF8244@cosmic.amd.com>
	<478FCDB6.4010708@i4.informatik.rwth-aachen.de>
	<20080117223644.GK8244@cosmic.amd.com>
	<478FDC12.6020505@i4.informatik.rwth-aachen.de>
	<20080119010624.GA25328@cosmic.amd.com>
	<47934B2E.3020707@i4.informatik.rwth-aachen.de>
	<20080121170700.GC6884@cosmic.amd.com>
	<4794E664.6020209@i4.informatik.rwth-aachen.de>
	<47B8413A.80105@lkml.darkvoyage.org.uk>
	<47B848A9.3080308@i4.informatik.rwth-aachen.de>
	<20080217145450.GB1403@cs181133002.pp.htv.fi>
	<47B85C61.7060507@lkml.darkvoyage.org.uk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 16:10:09 +0000
Iain Paton <ilp@lkml.darkvoyage.org.uk> wrote:

> Adrian Bunk wrote:
> > On Sun, Feb 17, 2008 at 03:46:01PM +0100, Arnd Hannemann wrote:
> >> Never tried to built it as a module.
> >> Probably there are issues with that. If I remember correctly I saw a patch in 2.6.25-rc which
> >> mentioned that using mfgpt in modules won't work. Does this apply to 2.6.24 as well?
> > 
> > For using code from modules it must be explicitely EXPORT_SYMBOL{,GPL}'ed.
> > 
> > Adding
> >   EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
> > and
> >   EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
> > below the respective functions in mfgpt_32.c should fix this issue.
> 
> I couldn't find the patch Arnd mentioned on lkml or in Linus git tree, 
> but adding the lines suggested by Adrian gets me a working module.
> 
> Hopefully the patch will arrive in the mainline tree at some point.
> 
 
This was originally split out into two separate patches; one that exported
the proper symbols, and the other containing the watchdog timer.  I merged
them in the geode tree.  The patch is here:

http://git.infradead.org/?p=geode.git;a=commitdiff;h=5a840828ddb5bb7381435509a9460e0ba4aab550

That's also checkpatch.pl happy (or at least, it was when I committed it).
