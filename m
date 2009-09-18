Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbZIRQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbZIRQFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIRQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:05:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:19407 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbZIRQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,410,1249282800"; 
   d="scan'208";a="728167141"
Date: Fri, 18 Sep 2009 17:00:48 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Amit Shah <amit.shah@redhat.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090918170048.53ba8cf6@linux.intel.com>
In-Reply-To: <4AB164A0.8000402@codemonkey.ws>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
	<20090916112332.6bf981a5@linux.intel.com>
	<4AB164A0.8000402@codemonkey.ws>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We do actually want hangup and a few other of the tty specific ops.
> The only thing we really don't want is a baud rate.

So you need break, parity ... no be serious please

> This device cannot be implemented as-is in userspace because it
> depends on DMA which precludes the use of something like uio_pci.  We
> could modify the device to avoid dma if the feeling was that there
> was no interest in putting this in the kernel.

So you need a tiny kernel side driver to unpack it into a meaningful
fs, or just a user-user channel with a daemon each end and a protocol
over it - nothing kernel in that.

We don't implement tcp/ip http sessions as tty devices with the kernel
as web server and the same logic applies here.
