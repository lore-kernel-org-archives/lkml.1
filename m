Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYFNMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYFNMlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYFNMlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:41:02 -0400
Received: from userg500.nifty.com ([202.248.238.80]:57161 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYFNMlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:41:00 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=h6vU4SQsU0BPVsHEUDvt9ke0VvaN6CkiE4yBra9CbblZmpJG032HSgqwAa43X7qOO
	+lvTpnpHMwfKMzq/ZThNw==
X-Nifty-SrcIP: [218.226.24.69]
Date: Sat, 14 Jun 2008 21:36:12 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080614213612.96873c25.komurojun-mbn@nifty.com>
In-Reply-To: <48537149.4040102@garzik.org>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008 03:20:41 -0400
Jeff Garzik <jeff@garzik.org> wrote:


After removing the 3-lines below in ata_eh_reset
the pata_pcmcia works properly.


-       spin_lock_irqsave(link->ap->lock, flags);
-       link->eh_info.serror = 0;
-       spin_unlock_irqrestore(link->ap->lock, flags);

Please fix this problem.

Best Regards
Komuro


> > 
> >>>>>> pcmcia: registering new device pcmcia1.1
> >>>>>> 1.1: GetNextTuple: No more items
> >>>>>> pata_pcmcia: probe of 1.1 failed with error -12
> > 
> > The patch "libata: kill hotplug related race condition"
> > introduced the pata_pcmcia error.
> > 
> > Please fix this problem.
> > 
> > 
> > Best Regards
> > Komuro
> > 
> >>> f046519fc85a8fdf6a058b4ac9d897cdee6f3e52 is first bad commit
> > commit f046519fc85a8fdf6a058b4ac9d897cdee6f3e52
> > Author: Tejun Heo <htejun@gmail.com>
> > Date:   Mon May 19 01:15:08 2008 +0900
> > 
> >     libata: kill hotplug related race condition
> >     
> >     Originally, whole reset processing was done while the port is frozen
> >     and SError was cleared during @postreset().  This had two race
> >     conditions.  1: hotplug could occur after reset but before SError is
> >     cleared and libata won't know about it.  2: hotplug could occur after
> >     all the reset is complete but before the port is thawed.  As all
> >     events are cleared on thaw, the hotplug event would be lost.
> 
> Interesting!  Thanks for the diagnosis...
> 
> 	Jeff
> 
> 
> 


-- 
Komuro <komurojun-mbn@nifty.com>
