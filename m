Return-Path: <linux-kernel-owner+w=401wt.eu-S1767586AbXCIWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767586AbXCIWox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767585AbXCIWox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:44:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44608 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767583AbXCIWow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:44:52 -0500
Date: Fri, 9 Mar 2007 23:48:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>
Subject: Re: [git patches] libata (and devres) fixes
Message-ID: <20070309234839.2070a265@lxorguk.ukuu.org.uk>
In-Reply-To: <b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
References: <20070309163148.GA12848@havoc.gtf.org>
	<b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> scsi1 : ata_piix
> ata2: port disabled. ignoring.
> ata2: reset failed, giving up    <--- THIS IS NEW.
> 
> However, I think it's just bogus as there is ata2 is disabled on this laptop.

This is expected behaviour and it is what every controller except the
PIIX has done for some time. I'm not sure its perfect but we could return
0 from the -ENOENT case in ata_eh_reset() if that is preferred.

