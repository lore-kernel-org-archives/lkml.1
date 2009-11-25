Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZKYLfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZKYLfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbZKYLfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:35:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33113 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758700AbZKYLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:35:25 -0500
Date: Wed, 25 Nov 2009 11:36:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: x86@kernel.org, Komuro <komurojun-mbn@nifty.com>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ioports 0x100-0x3af and iomem 0xd000-0xdffff,
 0xa0000000-0xa0ffffff -- safe to use on x86 for pcmcia?
Message-ID: <20091125113622.5b1218b0@lxorguk.ukuu.org.uk>
In-Reply-To: <20091124213723.GA22689@comet.dominikbrodowski.net>
References: <20091124213723.GA22689@comet.dominikbrodowski.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   This latter configuration file most often contains 
> 	include port 0x100-0x3af
> 	include memory 0xc0000-0xfffff
> 	include memory 0xa0000000-0xa0ffffff

Which crashes older thinkpads, some ATI chipset systems and
usually anything containing an NE2000 clone in ISA space.

> And so Komuro (CCed) suggested to add these default resource entries to the
> kernel, so that it can later use parts of these resource areas to enable
> PCMCIA devices without userspace interaction.
> 
> Do you think it would be safe to enable these areas by (kernel) default on
> x86? Of course, other entries in /proc/io{mem,ports} would be honoured, there
> would be a boot option to disable this feature, and some tests are run on the
> iomem and ioport resource areas.

The problem you have is that you change the ordering.

If you load the ne2k ISA driver before pcmcia (as occurs now because of
it being done from user space) the resources get claimed first. If you do
it the other way around and test then merely reading an I/O register
mapped to an NE2K or most NE2K clones crashes the machine.

Are there any modern systems where the PCI based autoconfig is
insufficient, or is this just ancient stuff  ?

Alan
