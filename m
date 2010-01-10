Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560Ab0AJOVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0AJOVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271Ab0AJOVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:21:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8172 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0AJOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LN5L/XXS+mFSvSZvRr1iEcBtzQKH30OPGqbb0Lc+ACflOUwfU0gUo2NpKIxOFxWLo0
         bQgB/i+BMUM5tS6xKOv8n1/92nzcZIkwIpL1+E6yfdzj0hkjvfxIijBlnTBN357mjOMR
         U8ylQ3awocGTR2aJ+5cxFHTMQ8Pf6E+0dAkD0=
MIME-Version: 1.0
In-Reply-To: <4B26349D.1080904@netone.com.tr>
References: <4B26349D.1080904@netone.com.tr>
Date: Sun, 10 Jan 2010 15:20:59 +0100
Message-ID: <8db1092f1001100620w59edea0ah5e7244e11930a005@mail.gmail.com>
Subject: Re: [BUG] Linux-2.6.32-git10 drm_i915 error
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Tarkan Erimer <tarkane@netone.com.tr>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/14 Tarkan Erimer <tarkane@netone.com.tr>:
> Frequently, I hit this bug on Linux-2.6.32-git10. It's always
> re-producible for me on my i945 video device equipped HP machine. When
> hit this bug, it crashes the X server and screen goes black. But,
> possible to switch to console. Here is the error log, I had in dmesg:
>
> [ 2596.328132] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [ 2596.328146] render error detected, EIR: 0x00000000
> [ 2596.328167] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
> returns -5 (awaiting 694588 at 694584)
> [ 2596.439006] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [ 2596.439013] render error detected, EIR: 0x00000000
>
> Tarkan

I confirm this. A observed this on 2.6.33-rc3-git3 after resume from suspend:

Jan 10 08:51:31 gumis kernel: [  486.880045]
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU
hung
Jan 10 08:51:31 gumis kernel: [  486.880063] render error detected,
EIR: 0x00000000
Jan 10 08:51:31 gumis kernel: [  486.880107]
[drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (
awaiting 60107 at 60105)
Jan 10 08:51:32 gumis kernel: [  487.276302] [drm:i915_gem_execbuffer]
*ERROR* i915_gem_do_execbuffer returns -5
Jan 10 08:51:32 gumis kernel: [  487.276799] [drm:i915_gem_execbuffer]
*ERROR* i915_gem_do_execbuffer returns -5
Jan 10 08:51:32 gumis kernel: [  487.277230] [drm:i915_gem_execbuffer]
*ERROR* i915_gem_do_execbuffer returns -5
Jan 10 08:51:32 gumis kernel: [  487.278308] [drm:i915_gem_execbuffer]
*ERROR* i915_gem_do_execbuffer returns -5
Jan 10 08:51:32 gumis kernel: [  487.278533] [drm:i915_gem_execbuffer]
*ERROR* i915_gem_do_execbuffer returns -5

2.6.33-rc2 works fine.
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
