Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYBQOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYBQOz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYBQOzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:55:19 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52528 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbYBQOzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:55:18 -0500
Date: Sun, 17 Feb 2008 16:54:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: Iain Paton <ilp@lkml.darkvoyage.org.uk>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
Message-ID: <20080217145450.GB1403@cs181133002.pp.htv.fi>
References: <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com> <47934B2E.3020707@i4.informatik.rwth-aachen.de> <20080121170700.GC6884@cosmic.amd.com> <4794E664.6020209@i4.informatik.rwth-aachen.de> <47B8413A.80105@lkml.darkvoyage.org.uk> <47B848A9.3080308@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B848A9.3080308@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 03:46:01PM +0100, Arnd Hannemann wrote:
> Hi,
> 
> Iain Paton wrote:
> > Arnd Hannemann wrote:
> > 
> >> I can confirm that it is still working fine :-)
> > 
> > Hi,
> > 
> > Has anyone managed to build this as a module against the full 2.6.24
> > release ?
> > 
> > I am seeing the following error:
> > 
> >   CC [M]  lib/zlib_inflate/infutil.o
> >   CC [M]  lib/zlib_inflate/inftrees.o
> >   CC [M]  lib/zlib_inflate/inflate_syms.o
> >   LD [M]  lib/zlib_inflate/zlib_inflate.o
> >   Building modules, stage 2.
> >   MODPOST 251 modules
> > ERROR: "geode_mfgpt_toggle_event" [drivers/watchdog/geodewdt.ko] undefined!
> > ERROR: "geode_mfgpt_alloc_timer" [drivers/watchdog/geodewdt.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > 
> > arch/x86/kernel/mfgpt_32.c where these are defined seems to have been
> > built ok and they appear in System.map.
> > 
> > The only other thing I've done is to add "[PATCH] pata_cs5536 Fix
> > secondary port configuration" recently posted by Martin K. Petersen but
> > I don't believe that would cause this.
> > 
> > .config is available at http://pastebin.ca/907299
> 
> Never tried to built it as a module.
> Probably there are issues with that. If I remember correctly I saw a patch in 2.6.25-rc which
> mentioned that using mfgpt in modules won't work. Does this apply to 2.6.24 as well?

For using code from modules it must be explicitely EXPORT_SYMBOL{,GPL}'ed.

Adding
  EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
and
  EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
below the respective functions in mfgpt_32.c should fix this issue.

> Best regards,
> Arnd Hannemann

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

