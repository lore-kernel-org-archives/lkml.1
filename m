Return-Path: <linux-kernel-owner+w=401wt.eu-S1031216AbXDZNJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031216AbXDZNJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031223AbXDZNJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:09:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48202 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031216AbXDZNJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:09:37 -0400
Date: Thu, 26 Apr 2007 14:13:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sworks-agp: Switch to PCI ref counting APIs
Message-ID: <20070426141306.59a954d8@the-village.bc.nu>
In-Reply-To: <20070425192158.8787a248.akpm@linux-foundation.org>
References: <20070423145129.1cfcd1f2@the-village.bc.nu>
	<20070425192158.8787a248.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 19:21:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Apr 2007 14:51:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >  {
> >  	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
> >  
> > +	pci_dev_put(bridge->dev);
> >  	agp_remove_bridge(bridge);
> >  	agp_put_bridge(bridge);
> > +	pci_dev_put(serverworks_private.svrwrks_dev)
> > +	serverworks_private.svrwrks_dev = NULL;
> 
> err, guys?

I merely fixed the code to refcount, the actual code itself is complete
bollocks and does exactly what that implies. It also explodes if you ever
use the hotplug testing code to simulate a plug or replug and goes
completely bonkers if you put two of them in a qemu simulator 8)

Alan
