Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267Ab0A0WYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0A0WYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227Ab0A0WYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:24:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755122Ab0A0WYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:24:24 -0500
Date: Wed, 27 Jan 2010 14:24:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, zhenyuw@linux.intel.com,
       yakui.zhao@intel.com
Subject: Re: i915: gpu wedged [was: mmotm 2010-01-15-15-34 uploaded]
Message-Id: <20100127142400.5657a7fe.akpm@linux-foundation.org>
In-Reply-To: <4B5AF1E5.1070304@gmail.com>
References: <201001152359.o0FNxVne006113@imap1.linux-foundation.org>
	<4B5AF1E5.1070304@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 13:56:05 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 01/16/2010 12:34 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-01-15-15-34 has been uploaded to
> 
> So I've decided to switch to KMS on this kernel with
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
> Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
> [VGA controller])
>         Subsystem: Intel Corporation 82G33/G31 Express Integrated
> Graphics Controller [8086:29c2]
>         Flags: bus master, fast devsel, latency 0, IRQ 26
>         Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
>         I/O ports at ec00 [size=8]
>         Memory at d0000000 (32-bit, prefetchable) [size=256M]
>         Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [d0] Power Management version 2
>         Kernel driver in use: i915
> 
> 
> with this X driver:
> (II) Module intel: vendor="X.Org Foundation"
>         compiled for 1.7.4, module version = 2.10.0
>         Module class: X.Org Video Driver
>         ABI class: X.Org Video Driver, version 6.0
> 
> 
> on X.Org X Server 1.7.4 and after some time I get:
> (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
> error
> (EE) intel(0): Failed to submit batch buffer, expect rendering
> corruption or even a frozen display: Input/output er
> ror.
> (WW) intel(0): i830_uxa_pixmap_swap_bo_with_image: bo map failed
> (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
> error
> (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
> error
> (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Input/output
> error
> (EE) intel(0): Failed to submit batch buffer, expect rendering
> corruption or even a frozen display: Input/output er
> ror.
> (EE) intel(0): Failed to submit batch buffer, expect rendering
> corruption or even a frozen display: Input/output er
> 
> 
> and kernel says:
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> render error detected, EIR: 0x00000000
> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
> (awaiting 153151 at 153150)
> [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -5
> 
> 
> >From <debugfs>/dri/0/i915_wedged, the GPU is wedged.
> 

umph.  There isn't much I can do about that, really.  Apart from
fervently hoping that this known regression doesn't turn up in
2.6.34-rc1.

