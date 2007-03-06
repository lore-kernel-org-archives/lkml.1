Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbXCFEWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbXCFEWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933938AbXCFEWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:22:41 -0500
Received: from smtp.cce.hp.com ([161.114.21.24]:46090 "EHLO
	ccerelrim03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbXCFEWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:22:40 -0500
Subject: Re: [patch] Add insmod option to force the use of the backup timer.
From: Alex Williamson <alex.williamson@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gerd Hoffmann <kraxel@suse.de>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Kevin Stansell <kstansel@us.ibm.com>
In-Reply-To: <20070305190333.c01a7ffc.akpm@linux-foundation.org>
References: <20070228102346.115707000@suse.de>
	 <20070228185505.GA17193@redhat.com> <45E6D309.5050409@suse.de>
	 <20070305190333.c01a7ffc.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP OSLO R&D
Date: Mon, 05 Mar 2007 21:22:32 -0700
Message-Id: <1173154952.5941.142.camel@bling>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.2.1.279297, Antispam-Engine: 2.4.0.264935, Antispam-Data: 2007.3.5.200935
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 19:03 -0800, Andrew Morton wrote:
> 
> Perhaps Alex can suggest some debugging steps we can take to work out
> why the test isn't triggering?

   I was lucky and had a hardware description of the bug I was trying to
work around with the 8250 backup timer patch.  If the UART on the system
in question is an integrated component, it might be worthwhile to start
with the errata documented in the hardware manual.

   The detection test is simply looking for UARTs that don't re-assert
the transmit holding register empty interrupt when it becomes
re-enabled.  Since the backup timer is successfully kicking the UART
back into action, it would be interesting to know whether this is
because the "Diva test" is detecting work to do or if it's just a matter
of reading the IIR bits (the interrupt is there, but not getting
delivered).  The state of the UART at that point may be a clue how to
detect the problem.

   UARTs often seem to be the most troubling part of a system, so I'm
not opposed to a boot/module option, but auto-detection provides a much
better user experience.  Thanks,

	Alex

-- 
Alex Williamson                             HP Open Source & Linux Org.

