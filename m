Return-Path: <linux-kernel-owner+w=401wt.eu-S1765659AbYBZVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765659AbYBZVc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765540AbYBZVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:32:05 -0500
Received: from xspect.dk ([212.97.129.87]:59175 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765473AbYBZVcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:32:03 -0500
Date: Tue, 26 Feb 2008 22:32:00 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
Message-ID: <20080226213200.GL17932@hjernemadsen.org>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <20080226085403.GI17932@hjernemadsen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226085403.GI17932@hjernemadsen.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also have a T61p, on which STR works. I haven't tried 2.6.25, but it
> works with 2.6.24. Both using the suspend scripts included in Ubuntu
> 7.10, and with s2ram 0.8 (although I need to use --acpi_sleep 2
> (s3_mode) as an option, instead of 1 (s3_bios), which is used by default
> on my model).
> 
> But I'm using the NVidia module, so that most likely changes a lot of
> things.  I'll see if I can find time tonight to test 2.6.25-rc3 + nv,
> and report back.
Ok. I've spent some time testing this. The good news is that with the nv
driver, s2ram as available from suspend.sf.net works, when run without
parameters on a 32-bit 2.6.24.3.

The bad news, however, is that it segfaults reliably after "Calling
get_mode" when I run it on 2.6.25-rc3. GDB shows that the segmentation
fault happens in the libx86 library, but as the version I use doesn't
have debug symbols, I don't have a complete backtrace. I'll try to
compile a version of libx86 tomorrow evening with debug symbols, and
return with a proper backtrace.

I have also tried to bisect the problem (its somewhere between 2.6.24
and 2.6.25rc1, quite a large span). However reverting the resulting
commit didn't solve the problem, I suspect I took a wrong turn
somewhere. I'll try to redo the bisection also tomorrow evening.

So I'll return with a proper bug report tomorrow (in its own thread). I
just wanted to give a heads up, if the above makes sense to anyone ;-)

--
Kind regards
 	Klaus S. Madsen

