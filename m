Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXDZNSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXDZNSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbXDZNSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:18:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38201 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbXDZNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:18:06 -0400
Date: Thu, 26 Apr 2007 14:21:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sworks-agp: Switch to PCI ref counting APIs
Message-ID: <20070426142108.44988793@the-village.bc.nu>
In-Reply-To: <20070426042019.GA11278@redhat.com>
References: <20070423145129.1cfcd1f2@the-village.bc.nu>
	<20070425192158.8787a248.akpm@linux-foundation.org>
	<20070426042019.GA11278@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 00:20:19 -0400
Dave Jones <davej@redhat.com> wrote:

> On Wed, Apr 25, 2007 at 07:21:58PM -0700, Andrew Morton wrote:
>  > On Mon, 23 Apr 2007 14:51:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>  > 
>  > >  {
>  > >  	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
>  > >  
>  > > +	pci_dev_put(bridge->dev);
>  > >  	agp_remove_bridge(bridge);
>  > >  	agp_put_bridge(bridge);
>  > > +	pci_dev_put(serverworks_private.svrwrks_dev)
>  > > +	serverworks_private.svrwrks_dev = NULL;
>  > 
>  > err, guys?
> 
> ? One put for the agp bridge, one for the host bridge.
> What am I missing?

Nothing - I assume Andrew was referring the bizarre way one of the
devices is global and one is per structure ?
