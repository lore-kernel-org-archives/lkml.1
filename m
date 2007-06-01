Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbXFAMyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbXFAMyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXFAMyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:54:32 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:56412 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXFAMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:54:32 -0400
Date: Fri, 1 Jun 2007 13:54:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: david-b@pacbell.net
Message-ID: <20070601125422.GA12204@srcf.ucam.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local> <20070531102603.GA16719@srcf.ucam.org> <20070601074606.GA6060@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601074606.GA6060@dose.home.local>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RTC_DRV_CMOS can break userspace interface
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:46:06AM +0200, Tino Keitel wrote:
> Yes, you are right. I think this issue should be covered by Kconfig.
> 
> However:
> 
> $ cat wakealarm 
> cat: wakealarm: Input/output error
> 
> It worked with /proc/acpi/alarm before.

Can you do 

for i in /sys/bus/pnp/devices/*; do if [ "$(cat $i/id)" = PNP0b00 ]; 
then cat $i/resources; echo options; cat $i/options; fi; done

and provide the output? It sounds like you have the same problem I do, 
that is that you have no IRQ listed in the PNP table.

Though, actually, on reading the code:

The code for checking for a platform device only gets included if 
CONFIG_PNP isn't set! David, surely this should be a runtime thing 
rather than a compile-time one? Right now building a kernel with PNP 
support will break horribly if it's then run on a non-PNP system...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
