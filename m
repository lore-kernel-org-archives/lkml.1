Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYJ0O6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYJ0O6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYJ0O61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:58:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:4089 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYJ0O60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Z41y4DLZqia+1RpOZpwIVjctJIQk3JAgiSNayMXWDbjDchovMjjclsqIZA0D9qA30E
         4WugvdX3rt9G3qF/z3/IivukY82OqXY3pMw4zmWLOg1guIwh4eFKC/OODvtuh7A+HcPs
         pPDWnPXg41s7N41V/joqecHeWwwu/6f4WDpEo=
Message-ID: <4905D750.7000006@tuffmail.co.uk>
Date: Mon, 27 Oct 2008 14:59:28 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc1: [drm:i915] *ERROR* ... Disabling tiling
References: <4905CFC3.1060907@tuffmail.co.uk>
In-Reply-To: <4905CFC3.1060907@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> What does this mean, should I do anything about it?  Is tiling nice to have?
>
> It sounds like GEM broke something - though maybe it just added a more 
> verbose error report.
>
> System: EeePC 701
> Kernel: v2.6.36-rc1-5-g23cf24c
> Chipset: Intel mobile 915G-something
> Regretably necessary kernel boot option: noapic
>
>
> [    1.438441] Linux agpgart interface v0.103
> [    1.438441] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
> [    1.438441] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> [    1.443353] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    1.443353] [drm] Initialized drm 1.1.0 20060810
> [    1.443353] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 
> (level, low) -> IRQ 5
> [    1.443353] pci 0000:00:02.0: setting latency timer to 64
> [    1.443353] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read 
> from MCHBAR.  Disabling
> tiling.
> [    1.443353] [drm:i915_driver_load] *ERROR* failed to enable MSI
>
>
> I expect noapic explains the MSI failure.  I can boot without noapic if 
> necessary for testing, but I can't run with it because I get nasty hangs 
> & reboots.  I don't see why that merits an *ERROR*... anyway, what I'm 
> interested in is the "Disabling tiling".
>   

Actually... MSI does seem to be working for my ethernet.

$ grep eth /proc/interrupts
 44:       2446   PCI-MSI-edge      eth1

DRM wasn't using MSI in 2.6.27 though.  So I'm still doubtful that the 
MSI issue is really an "*ERROR*".

Thanks
Alan
