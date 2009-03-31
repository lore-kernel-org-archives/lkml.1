Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbZCaTur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbZCaTur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZCaTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:50:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36982 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753627AbZCaTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:50:37 -0400
Date: Tue, 31 Mar 2009 20:23:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gabor Kovacs <kgabor@bolyai.elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport: Use the PCI IRQ if offered
Message-ID: <20090331202316.3b350772@the-village.bc.nu>
In-Reply-To: <200903311531.56965.kgabor@bolyai.elte.hu>
References: <20090326205558.5686.36265.stgit@localhost.localdomain>
	<49CC046A.7040209@garzik.org>
	<200903311531.56965.kgabor@bolyai.elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 15:31:56 -0400
Gabor Kovacs <kgabor@bolyai.elte.hu> wrote:

> Hi Alan,
> 
> just to confirm, IRQ detection works fine on my Lava parallel card. 
> 
> The instrument driver module that registers an irq handler via 
> parport_register_device gets false events when parport irq is shared e.g. with 
> an ethernet controller. Should irq sharing awareness go to our handler 
> function or parport_irq_handler/parport_generic_irq still needs some 
> additional patch? (Or have I just missed this second patch?)

I suspect it may have to go in the handler functions to avoid the risk of
losing any state reading the registers to see an IRQ is pending. The
ideal case would be to keep it in the common code path however.

I've not looked at that so far as a lot of hardware is just fine without
the checks. I guess try it and see with your actual hardware
