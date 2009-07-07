Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZGGXqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZGGXqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZGGXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:46:22 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5237 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbZGGXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:46:21 -0400
X-IronPort-AV: E=Sophos;i="4.42,365,1243828800"; 
   d="scan'208";a="3567805"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Boot Consoles question...
Date: Tue, 7 Jul 2009 19:49:41 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <20090704102904.GB32257@elte.hu> <200907041207.42388.rgetz@blackfin.uclinux.org>
In-Reply-To: <200907041207.42388.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907071949.41311.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Jul 2009 23:46:19.0880 (UTC) FILETIME=[207BDE80:01C9FF5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 4 Jul 2009 12:07, Robin Getz pondered:
> On Sat 4 Jul 2009 06:29, Ingo Molnar pondered:
> > Could be changed i guess ... but is it really an issue?
> 
> It is just a change from "normal" (when the kernel has no boot console).
> 
> >  One artifact 
> >  could be manual scroll-back - it would perhaps be nice indeed to
> >  allow the scrollback to the top of the bootlog.
> 
> Exactly.
> 
> One of my thoughts (was since CON_PRINTBUFFER isn't used after 
> register_console()) - was for the CON_BOOT's CON_PRINTBUFFER flag to control 
> the clearing of the CON_PRINTBUFFER for the real console or not...
> 
> All early_printk consoles that I looked at have their CON_PRINTBUFFER set.
> 
> Which means that something like should do the trick -- allow people who want 
> to override things to do so, and still have the today's setup work as is...

I guess no one liked that idea?

How about at least making sure that the real console gets a message that
something is on the bootconsole? Right now the switch message:

console handover:boot [early_shadow0]  -> real [ttyBF0]

only is printed on the bootconsole, not on the real console - so someone 
looking at the real console may not know there is anything on the boot 
console. They just think that things are missing...

-Robin





