Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYFNDGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYFNDGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 23:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYFNDFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 23:05:52 -0400
Received: from userg500.nifty.com ([202.248.238.80]:42097 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYFNDFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 23:05:51 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=KDZZEzJIW+E8/bpCU7emBda/4bqmeD4cQ+x0fJxZtzjwRPkn4HQ7YbYc/06v8rxgo
	nWj03BIDRsyOxrnrciIWw==
X-Nifty-SrcIP: [218.226.24.69]
Date: Sat, 14 Jun 2008 12:00:55 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
In-Reply-To: <20080611072029.GB28692@comet.dominikbrodowski.net>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Tejun

> > > > > pcmcia: registering new device pcmcia1.1
> > > > > 1.1: GetNextTuple: No more items
> > > > > pata_pcmcia: probe of 1.1 failed with error -12

The patch "libata: kill hotplug related race condition"
introduced the pata_pcmcia error.

Please fix this problem.


Best Regards
Komuro

> > f046519fc85a8fdf6a058b4ac9d897cdee6f3e52 is first bad commit
commit f046519fc85a8fdf6a058b4ac9d897cdee6f3e52
Author: Tejun Heo <htejun@gmail.com>
Date:   Mon May 19 01:15:08 2008 +0900

    libata: kill hotplug related race condition
    
    Originally, whole reset processing was done while the port is frozen
    and SError was cleared during @postreset().  This had two race
    conditions.  1: hotplug could occur after reset but before SError is
    cleared and libata won't know about it.  2: hotplug could occur after
    all the reset is complete but before the port is thawed.  As all
    events are cleared on thaw, the hotplug event would be lost.
    

> > > > > pcmcia: registering new device pcmcia1.0
> > > > ...
> > > > > pcmcia: registering new device pcmcia1.1
> > > > > 1.1: GetNextTuple: No more items
> > > > > pata_pcmcia: probe of 1.1 failed with error -12
> > 
> > This problem is introduced at kernel 2.6.26-rc4.
> > 
> > The kernel 2.6.26-rc3 does not have this problem.
> 
> 
> git-diff drivers/pcmcia is empty for 2.6.26-rc3 to 2.6.26-rc4. Therefore,
> it looks like something in the ata codepaths introduced this error? Tejun,
> Jeff, any ideas? (original bugreport below)
> 
> Thanks,
> 	Dominik
> 
> > > > Hi,
> > > > 
> > > > > Ive added the id123 strings for a Sandisk Extreme III 8GB.
> > > > > I get this when using pcmcia->CF adapter.
> > > > 
> > > > > pcmcia: registering new device pcmcia1.0
> > > > ...
> > > > > pcmcia: registering new device pcmcia1.1
> > > > > 1.1: GetNextTuple: No more items
> > > > > pata_pcmcia: probe of 1.1 failed with error -12
> > > > 
> > > > Is that a multifunction device? It seems to me that something is broken in
> > > > the device CIS, for both drives seem to be exported already by device
> > > > pcmcia1.0.
> > > 
> > > Its a simply pcmcia->CF adapter and the CF card is a simple storage one. I got it to work through USB-adapter after replacing my
> > > broken one.
> > > However it still doesnt work through the pcmcia->CF adapter.
> > > 
> > > Im not ruling out that its broken though.
> > > 
> > > > 
> > > > Best,
> > > > 	Dominik


