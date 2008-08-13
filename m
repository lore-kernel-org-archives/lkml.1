Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYHMHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYHMHtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYHMHs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:48:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37137 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYHMHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:48:26 -0400
Date: Wed, 13 Aug 2008 09:39:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: Milan Broz <mbroz@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
	(bisected)
Message-ID: <20080813073928.GB19877@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <48A1A4F6.9080706@redhat.com> <48A1B0CB.9050908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A1B0CB.9050908@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 17:48:27, Milan Broz wrote:
> 
> >>>> yes. maybe some userspace tool controlling frequency is involved, no idea yet.
> >>>> But it is 2.6.26 tree for sure.
> >>>>         
> >>> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
> >>>       
> >
> >
> > The bug is _not_ in 2.6.26, it was introduced in 2.6.26.1.
> >
> > The problem is, that now the CPU frequency doesn't decrease at some
> > temperature level and fan is unable to cool it properly.
> >
> > bisect on 2.6.26.y tree finished in this patch:
> > (I expect similar patch in 2.6.27-rc)
> >
> > commit 04f496871e8af87a1e40c504371a206fd7389193
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Wed Jul 30 18:20:10 2008 +0000
> >
> >   
> and this seems to fix it for me:
> --
> 
> Do not use unsigned int if there is test for negative number...
> 
> See drivers/acpi/processor_perflib.c
>   static unsigned int ignore_ppc = -1;
> ...
>   if (event == CPUFREQ_START && ignore_ppc <= 0) {
>        ignore_ppc = 0;
> ...
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Tested-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
