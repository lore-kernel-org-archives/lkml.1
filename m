Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXIYTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXIYTiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXIYTiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:38:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45526 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXIYTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:38:06 -0400
Date: Tue, 25 Sep 2007 21:38:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.8, pata_ali issue
In-Reply-To: <20070925173525.GA32185@suse.de>
Message-ID: <Pine.LNX.4.64.0709252116180.945@fbirervta.pbzchgretzou.qr>
References: <20070925062115.GA18444@kroah.com>
 <6101e8c40709250909x53b44274i17694e64dccae427@mail.gmail.com>
 <20070925161430.GA14212@suse.de> <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
 <20070925173525.GA32185@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25 2007 10:35, Greg KH wrote:
>On Tue, Sep 25, 2007 at 07:03:24PM +0200, Jan Engelhardt wrote:

>> So, here is something that I think should go into the next 2.6.22.
>> A proper fix is already in 2.6.23-git-du-jour.
>
>Feel free to send the patch, with the git commit id of the upstream
>commit to the stable@kernel.org address and we will be glad to review it
>that way.

'right, it is already in the mainline kernel.
So it's again the suse kernel src rpm that has it screwed up...
another story. Here's your culprit:

libata-update-libata-to-libata-dev-upstream-5ddf.patch
* Replaces ali_init_chipset() with some new bits, essentially
  it removes the call to pci_read_config_byte() since the
  revision is now found in struct pci_dev->revision
  Basically 2.6.23 stuff.

libata-fix-up-build-after-upstream-update.patch
* changes it back to the 2.6.22 api, so that it compiles again.
  But only that.
  It FORGETS to add pci_read_config_byte() back.

=== libata-fix-up-build-after-upstream-update.patch
>From 54ee7cd26c5e438dc15d13b60c9f8a54ca05e3fb Mon Sep 17 00:00:00 2001          
From: Tejun Heo <htejun@gmail.com>                                              
Date: Fri, 3 Aug 2007 02:21:51 +0900                                            
Subject: [PATCH] libata: fix up build after upstream update                     
References: 288078                                                              
                                                                                
Signed-off-by: Tejun Heo <htejun@gmail.com>                                     
===

The bug is still present in current suse kotd. >:-(

Please fix it there. A cc will go to opensuse-kernel@,
but other than that, I am in the wrong mood right now to do anything.
