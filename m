Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435Ab0AJThL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0AJThL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 14:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895Ab0AJThK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 14:37:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:41476 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0AJThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 14:37:09 -0500
Date: Sun, 10 Jan 2010 23:37:03 +0400
From: Constantin Baranov <const@mimas.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Tarkan Erimer <tarkane@netone.com.tr>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.32-git10 drm_i915 error
Message-Id: <20100110233703.9060e075.const@mimas.ru>
In-Reply-To: <201001101933.39683.rjw@sisk.pl>
References: <4B26349D.1080904@netone.com.tr>
	<8db1092f1001100620w59edea0ah5e7244e11930a005@mail.gmail.com>
	<201001101933.39683.rjw@sisk.pl>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 19:33:39 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Sunday 10 January 2010, Maciej Rutecki wrote:
> > 2009/12/14 Tarkan Erimer <tarkane@netone.com.tr>:
> > > Frequently, I hit this bug on Linux-2.6.32-git10. It's always
> > > re-producible for me on my i945 video device equipped HP machine. When
> > > hit this bug, it crashes the X server and screen goes black. But,
> > > possible to switch to console. Here is the error log, I had in dmesg:
> > >
> > > [ 2596.328132] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> > > elapsed... GPU hung
> > > [ 2596.328146] render error detected, EIR: 0x00000000
> > > [ 2596.328167] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
> > > returns -5 (awaiting 694588 at 694584)
> > > [ 2596.439006] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> > > elapsed... GPU hung
> > > [ 2596.439013] render error detected, EIR: 0x00000000
> > >
> > > Tarkan
> > 
> > I confirm this. A observed this on 2.6.33-rc3-git3 after resume from suspend:
> > 
> > Jan 10 08:51:31 gumis kernel: [  486.880045]
> > [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU
> > hung
> > Jan 10 08:51:31 gumis kernel: [  486.880063] render error detected,
> > EIR: 0x00000000
> > Jan 10 08:51:31 gumis kernel: [  486.880107]
> > [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (
> > awaiting 60107 at 60105)
> > Jan 10 08:51:32 gumis kernel: [  487.276302] [drm:i915_gem_execbuffer]
> > *ERROR* i915_gem_do_execbuffer returns -5
> > Jan 10 08:51:32 gumis kernel: [  487.276799] [drm:i915_gem_execbuffer]
> > *ERROR* i915_gem_do_execbuffer returns -5
> > Jan 10 08:51:32 gumis kernel: [  487.277230] [drm:i915_gem_execbuffer]
> > *ERROR* i915_gem_do_execbuffer returns -5
> > Jan 10 08:51:32 gumis kernel: [  487.278308] [drm:i915_gem_execbuffer]
> > *ERROR* i915_gem_do_execbuffer returns -5
> > Jan 10 08:51:32 gumis kernel: [  487.278533] [drm:i915_gem_execbuffer]
> > *ERROR* i915_gem_do_execbuffer returns -5
> > 
> > 2.6.33-rc2 works fine.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=15026 perhaps?

I have caught this bug in 2.6.31.9, 2.6.32.2, 2.6.33-rc3 and 2.6.33-rc3-git3
on my Acer Aspire 1410T with Intel GM45 chipset. It is not needed to perform
suspend and resume to reproduce the bug. The bug appears for me at startup
of the Stellarium (trunk version).
