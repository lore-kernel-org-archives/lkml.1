Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZHPOkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZHPOkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZHPOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:40:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38839 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZHPOkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:40:11 -0400
From: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>
To: Jeff Garzik <jeff@garzik.org>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Sun, 16 Aug 2009 20:05:47 +0530
Subject: RE: sata AHCI controller over non-PCI bus
Thread-Topic: sata AHCI controller over non-PCI bus
Thread-Index: AcoecJvJ+HcB8kQaSMuHVxvSxvDYRQADWNow
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702F4E077E1@dbde02.ent.ti.com>
References: <FCCFB4CDC6E5564B9182F639FC35608702F5989152@dbde02.ent.ti.com>
 <4A7FE245.8020002@ru.mvista.com>
 <FCCFB4CDC6E5564B9182F639FC35608702F59891CB@dbde02.ent.ti.com>,<4A88014D.9060309@garzik.org>
In-Reply-To: <4A88014D.9060309@garzik.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

I can work on the seperation aspects as I need to get the OMAPL138 SATA solution working.  I will try to provide a basic implementation by end of this week.  Pl. provide your feedback on the same if we need to further refine it to address broad use cases.

Thanks for your response.

regards
swami

________________________________________
From: Jeff Garzik [jeff@garzik.org]
Sent: Sunday, August 16, 2009 6:23 PM
To: Subbrathnam, Swaminathan
Cc: Sergei Shtylyov; linux-ide@vger.kernel.org; LKML
Subject: Re: sata AHCI controller over non-PCI bus

Subbrathnam, Swaminathan wrote:
> Jeff,
>       From the below link (from Sergei) it seems that you have already re-factored the AHCI implementation dependency on PCI.  I would like to add support for the OMAPL138 SATA on top of your changes.  That would be the ideal way forward for me.
>
>       Have the ahci re-factoring changes queued for mainline merge already?  I just joined the list and hence do not know the status.
>
> Sergei,
>       Appreciate the response.

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