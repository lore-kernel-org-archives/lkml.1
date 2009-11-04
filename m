Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZKDOUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZKDOUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZKDOUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:20:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbZKDOUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:20:39 -0500
Date: Wed, 4 Nov 2009 16:17:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alex Williamson <alex.williamson@hp.com>,
       Mark McLoughlin <markmc@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: virtio-net: new section mismatch warning. revert patch?
Message-ID: <20091104141729.GA27288@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v2.6.32-rcX I started getting section mismatch warnings for
virtio_net.
make with CONFIG_DEBUG_SECTION_MISMATCH=y shows:

WARNING: drivers/net/virtio_net.o(.data+0x90): Section mismatch in
reference from the variable virtio_net to the function
.devexit.text:virtnet_remove()                                                                    
The variable virtio_net references                                                                            
the function __devexit virtnet_remove()                                                                       
If the reference is valid then annotate the                                                                   
variable with __exit* (see linux/init.h) or name the variable:                                                
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,                                  

virtnet_remove was converted to devexit by this commit:

	commit 3d1285beff2e8467b8c3884d83b7a91a99aa9fcd
	Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
	Date:   Wed Sep 30 22:28:34 2009 +0000

	    move virtnet_remove to .devexit.text

We didn't have these warnings in v2.6.31, so this is a regression.
revert?

-- 
MST
