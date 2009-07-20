Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZGTVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZGTVuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZGTVuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:50:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:55138 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892AbZGTVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,236,1246863600"; 
   d="scan'208";a="476509629"
Date: Mon, 20 Jul 2009 23:48:29 +0100
From: Alan Cox <alan@linux.intel.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090720234829.1b32b2c0@t61.ukuu.org.uk>
In-Reply-To: <1248112313-7842-1-git-send-email-daniel@caiaq.de>
References: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk>
	<1248112313-7842-1-git-send-email-daniel@caiaq.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason is that the serial port's resources are freed upon
> disconnect (in serial_hangup()) but the tty device layer is not made
> aware of that. Hence, the close callback will later access the
> resources again.

tty_port_hangup() is part of the hangup path and the physical resources
should not be touched after the hangup completes. It's a good
indication of where the bug might be but its not I suspect the fix as
we now leak the resources.

