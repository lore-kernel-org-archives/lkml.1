Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZHPMxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZHPMxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZHPMxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:53:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39973 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZHPMxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:53:36 -0400
Message-ID: <4A88014D.9060309@garzik.org>
Date: Sun, 16 Aug 2009 08:53:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sata AHCI controller over non-PCI bus
References: <FCCFB4CDC6E5564B9182F639FC35608702F5989152@dbde02.ent.ti.com> <4A7FE245.8020002@ru.mvista.com> <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com>
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subbrathnam, Swaminathan wrote:
> Jeff,
> 	From the below link (from Sergei) it seems that you have already re-factored the AHCI implementation dependency on PCI.  I would like to add support for the OMAPL138 SATA on top of your changes.  That would be the ideal way forward for me.
> 
> 	Have the ahci re-factoring changes queued for mainline merge already?  I just joined the list and hence do not know the status.
> 
> Sergei,
> 	Appreciate the response.

I store the refactoring in git, on the "libahci" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

Unfortunately, I am having second thoughts about an element of the 
current design.  With current Linux distributions, they do not appear to 
deal well with the multi-module dependency libata -> libahci -> ahci. 
If I had to guess, I would say that mkinitrd creation tools only look at 
one tree level's worth of kernel module dependencies.

Thus, ahci would wind up -not- in initrd, in a libahci solution.

I am thinking that I will just add Marvell and ATP support to ahci.c, 
and let someone else deal with libahci separation -- which is still needed.

At this point, I would rather get Marvell/ATP support into users' hands, 
rather than wait for distros to catch up to modern technology.

	Jeff




