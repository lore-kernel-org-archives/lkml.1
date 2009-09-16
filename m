Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZIPK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZIPK3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZIPK27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:28:59 -0400
Received: from mga05.intel.com ([192.55.52.89]:28784 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750801AbZIPK26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="727424061"
Date: Wed, 16 Sep 2009 11:23:32 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Amit Shah <amit.shah@redhat.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090916112332.6bf981a5@linux.intel.com>
In-Reply-To: <4AAA8A56.3040707@codemonkey.ws>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This device is very much a serial port.  I don't see any reason not
> to treat it like one.

Here are a few

- You don't need POSIX multi-open semantics, hangup and the like
- Seek makes sense on some kinds of fixed attributes
- TTY has a relatively large memory overhead per device
- Sysfs is what everything else uses
- Sysfs has some rather complete lifetime management you'll need to
  redo by hand
- You don't need idiotic games with numbering spaces

Abusing tty for this is ridiculous. In some ways putting much of it in
kernel is ridiculous too as you can do it with a FUSE fs or simply
export the info guest-guest using SNMP.

Alan
