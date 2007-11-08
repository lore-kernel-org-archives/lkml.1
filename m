Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXKHCKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXKHCKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXKHCKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:10:11 -0500
Received: from ozlabs.org ([203.10.76.45]:44849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbXKHCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:10:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: Module init call vs symbols exporting race?
Date: Thu, 8 Nov 2007 13:10:07 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <473031FA.2060707@openvz.org> <200711062341.34566.rusty@rustcorp.com.au> <1194429690.6874.7.camel@localhost.localdomain>
In-Reply-To: <1194429690.6874.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081310.07697.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 21:01:30 Jan Glauber wrote:
> Hi Rusty,
>
> I've seen a symbol-resolving race on s390. The qeth module uses symbols
> from qdio and although the loading order seems correct and the qdio
> symbols should be available the following error appears:
>
> qdio: loading QDIO base support version 2
> qeth: Unknown symbol qdio_synchronize

Looks like qdio does something which triggers qeth to load, but of course qdio 
isn't finished initializing yet so its symbols aren't available.

It's not obvious what's triggering the load, but you could probably find it by 
using printk's through qdio.c's init_QDIO().

Cheers,
Rusty.
