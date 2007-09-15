Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbXIOQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbXIOQxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbXIOQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:53:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXIOQxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:53:47 -0400
Date: Sat, 15 Sep 2007 09:56:28 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Volkmann <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, zaitcev@redhat.com
Subject: Re: 2.6.23-rc6: usb 1-1: device not accepting address 2, error -62
Message-Id: <20070915095628.491c8a86.zaitcev@redhat.com>
In-Reply-To: <20070915034819.3e695370.akpm@linux-foundation.org>
References: <46EAFCF7.1030907@cv-sv.de>
	<20070915034819.3e695370.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.11.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 03:48:19 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> > I have an error message with 2.6.23-rc6.
> > This did not happen with 2.6.22.
> 
> Another one for Michal's dirt file.

No, I think it's the module ordering again.

> > 2.6.23-rc6 boot.msg extract ( hub/usb )

I wish users stopped this filtering, it's a very bad idea.

As it is, there's no message showing when ehci_hcd was loaded.
We can try piece together the picture:

> > <6>usb usb1: configuration #1 chosen from 1 choice
> > <6>hub 1-0:1.0: USB hub found
> > <6>hub 1-0:1.0: 2 ports detected
> > <6>usb usb2: configuration #1 chosen from 1 choice
> > <6>hub 2-0:1.0: USB hub found
> > <6>hub 2-0:1.0: 2 ports detected
> > <6>usb 1-1: new low speed USB device using ohci_hcd and address 2

ok this was ohci_hcd

> > <3>usb 1-1: device not accepting address 2, error -62
> > <6>usb 5-2: new full speed USB device using uhci_hcd and address 2

was ehci here? We don't know but I bet it was, because:

> > <6>usb 6-2: new high speed USB device using ehci_hcd and address 2

> > 2.6.22 boot.msg extract ( hub/usb )

This one seems far shorter. The EHCI comes online late here as well,
but not as late as in the "regression" case. I am wondering if we
have some kind of "parallel PCI probing" option in action here.

-- Pete
