Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbXEPSLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbXEPSLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXEPSLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:11:40 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:4435 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756223AbXEPSLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:11:39 -0400
Date: Wed, 16 May 2007 20:11:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_BREAK_MY_MACHINE
Message-ID: <20070516201143.699cff02@hyperion.delvare>
In-Reply-To: <20070515203059.GI6816@ucw.cz>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	<20070514081022.7fcee97f@hyperion.delvare>
	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	<20070514141437.631fcfd1@hyperion.delvare>
	<20070515203059.GI6816@ucw.cz>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:31:00 +0000, Pavel Machek wrote:
> Hi!
> 
> > > Hardware Monitoring support  --->
> > >   <*> Hardware Monitoring support
> > >   <*> Abit uGuru
> > >   <M> VIA686A
> > >   <*> IBM Hard Drive Active Protection System (hdaps)
> > > 
> > > But I'm quite sure that the only module used is VIA686A (I'm
> > > rebuilding to confirm).
> > 
> > This is a rather bad idea to build the abituguru and hdaps drivers into
> > your kernel if you don't have these devices. Especially abituguru, as
> > it does arbitrary port probing.
> 
> hdaps should be safe (DMI based whitelist, no?)

Correct.

> If abitguru breaks random machines, we probably should DMI whitelist,
> too.

I never said it was breaking machines, just that it was accessing
arbitrary I/O ports.

This was already discussed with the driver's author (Hans de Goede,
Cc'd) and I think we agreed on the principle, but it didn't happen yet.
This device only exists on Abit motherboards so it would be easy enough
to check the DMI vendor. A more detailed white list is also possible,
but I'm not insisting on it.

The driver could also be made to depend on X86, as this is the only
architecture where it is useful.

Hans, can you please submit a patch doing this?

Thanks,
-- 
Jean Delvare
