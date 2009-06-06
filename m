Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZFFN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZFFN3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFFN3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:29:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:57670 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZFFN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:29:14 -0400
Date: Sat, 6 Jun 2009 15:28:47 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: e_powersaver / underclocking (was Re: Linux 2.6.30-rc8 [also: VIA
	Support])
Message-ID: <20090606132847.GB14088@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org> <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain> <200906060717.46964.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906060717.46964.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 07:17:44AM -0500, Michael S. Zick wrote:

> I can respond to that point now; VIA Tech has answered some of my questions -
> 
> The mainstream kernel, e_powersaver, is *under-clocking* my machine -
> 
> The cpuid instruction provides the minimum and maximum GSF values 
> (Guaranteed Stable Frequency) for that processor mask run -
> Passing that on as the lower and upper limits to e_powersaver should
> stop that problem.  Will be testing this RSN.

It's really surprising to me that none of this seems to be handled correct so
far, I'll talk to Centaur and try to find out how we could have ended up in
this situation.

My assumption is that e_powersavre is no longer supposd to do any of those
low-level bits - rather the ACPI code is expected to get it right, hiding the
details from the OS.  But in this case, there needs to be some run-time detection
whether the ACPI cpufreq should be used, or e_powersaver.  And I don't see any
of that right now.

Also note that now with OLPC XO1.5 going for the C7-M (on a VX855 chipset,
though), many of those issues should soon receive much more attention -
especially on the power management front.  And as you know, they don't use any
legacy BIOS...

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
