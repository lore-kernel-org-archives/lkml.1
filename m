Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYE0GBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYE0GBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYE0GA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:00:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYE0GA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:00:58 -0400
Date: Mon, 26 May 2008 23:00:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080526230022.682688e9@infradead.org>
In-Reply-To: <1211867031.10205.13.camel@shinybook.infradead.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	<483B2A9B.4050007@krogh.cc>
	<alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
	<20080526172519.10d944ab@infradead.org>
	<1211867031.10205.13.camel@shinybook.infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 06:43:51 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2008-05-26 at 17:25 -0700, Arjan van de Ven wrote:
> > btw this guy has shown up on kerneloops.org a lot: 
> > http://www.kerneloops.org/searchweek.php?search=__ioremap_caller
> > where it's trying to map memory as uncachable, which is.. well nasty
> > (it seems to map not just the piece it needs, but more, and then
> > turns that "more" uncachable, even if the kernel is using it for
> > "normal" things)
> 
> The driver needs that 'more' to reach the lock registers for the flash
> chip. If it's being used for other things, shouldn't the
> request_region() fail?

it does fail....
... and then the driver continues anyway!

        if (request_resource(&iomem_resource, &window->rsrc)) {
                window->rsrc.parent = NULL;
                printk(KERN_ERR MOD_NAME   
                        " %s(): Unable to register resource"
                        " 0x%.016llx-0x%.016llx - kernel bug?\n",
                        __func__,
                        (unsigned long long)window->rsrc.start,
                        (unsigned long long)window->rsrc.end); 
        }

notice the lack of "return" or "goto out" etc ;)

> 
> On a vaguely related note, there's a lot to be said for _not_ using
> the standard PCI driver setup on the BIOS flash drivers, and going
> back to having them manually loaded rather than being automatically
> loaded whenever the appropriate southbridge is present.
> 
> It would be nicer if the only people who have write access to their
> BIOS flash are the ones who _really_ wanted it.

absolutely

do we need a MODULE_NO_AUTOLOAD() ?

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
