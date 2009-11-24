Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZKXArJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZKXArJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZKXArI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:47:08 -0500
Received: from usul.overt.org ([204.11.33.43]:59405 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbZKXArI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:47:08 -0500
X-Greylist: delayed 1544 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 19:47:07 EST
Date: Mon, 23 Nov 2009 16:21:19 -0800
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, philipl@alumni.utexas.net
Subject: Re: The work of ricoh_mmc isn't detected by pci core
Message-ID: <20091123162119.3777e14d@fido2.homeip.net>
In-Reply-To: <1259021583.16650.9.camel@maxim-laptop>
References: <1259021583.16650.9.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 02:13:03 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Hi,
> 
> I noticed that usage of ricoh_mmc will lead to this
> 
> 
> 07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
> Host Adapter (rev 22) 07:00.2 System peripheral: Ricoh Co Ltd R5C843
> MMC Host Controller (rev 12) 07:00.3 System peripheral: Ricoh Co Ltd
> R5C592 Memory Stick Bus Host Adapter (rev 12) 07:00.4 System
> peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)
> 
> 
> I don't have yet an MMC card to test if the driver itself working, 
> but what happens is that once disabled, all pci functions shift 
> one level, but kernel doesn't pick that up.
> 
> If one implements drivers for XD and memstick parts, this would break
> everything. (And I have some plans for XD part)
> 
> ricoh_mmc is built-in, but this doesn't help.
> 
> Best regards,
> Maxim Levitsky

Hmm, yes, that's true (and if you do a warn reboot, the effect is
sticky and then MMC is missing). I don't know how to make the pci
core re-enumerate devices, but maybe there is a way. I'm not in
a position to do this myself in the near future; so I'm afraid
that if you need this fixed, you'll have to do the digging.

Is it sufficient to call pci_rescan_bus at the end of the disable/enable
routine in ricoh_mmc?

--phil
