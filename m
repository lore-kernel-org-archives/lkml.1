Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYIMMqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYIMMqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 08:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYIMMqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 08:46:33 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:20666 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbYIMMqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 08:46:33 -0400
Message-ID: <48CBB626.4050300@msgid.tls.msk.ru>
Date: Sat, 13 Sep 2008 16:46:30 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Stable regression: usb-storage is stuck in 2.6.26.5
References: <20080913122143.4B13B908E@gandalf.tls.msk.ru>
In-Reply-To: <20080913122143.4B13B908E@gandalf.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Just updated my machine from 2.6.26.1 to 2.6.26.5, and it does not
> wan to boot anymore.  It says "Initializing USB Mass Storage driver.."
> (when trying to load usb-storage module) and sits here forever, every
> 2 minutes showing warnings about stuck processes (traces below).
> With 2.6.26.1 or any previous version I never experienced this
> problem.  Both 32- and 64-bits kernels behave the same way.
> While waiting for usb-storage to complete, no other USB devices
> works (incl. mouse and keyboard).
> 
> The machine is an AMD X2-64 (BE-2400) processor with an nVidia MCP51
> chipset (lspci is below).  Motherboard is Asus M2NPV-VM, latest BIOS
> (1401, dated 08/07/2008)
> 
> I'm rebuilding 2.6.26.3 for now -- trying to bisect the issue...
[...]

And it's more: even without usb-storage, other USB devices does
not work, waiting in the same usb_start_wait_urb.

Ok, it turned out to be pretty.. interesting.

It's not a regression within -stable kernel series.  The problem
happens when BOTH are true:

   - using latest BIOS for this mobo (1401), AND
   - enabling KVM_GUEST in kernel.

The only difference in my kernel config between .1 and .5 was
to enable KVM_GUEST and KVM_CLOCK, and also I2C_HELPER_AUTO
which was added by kernel update.

Going with previous BIOS (1201) OR disabling PARAVIRT_GUEST
fixes the problem.  I'll try to figure out which config
option is at problem here.

> Thanks.
> 
> /mjt
> 
