Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZKEEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZKEEkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 23:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZKEEkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 23:40:52 -0500
Received: from ozlabs.org ([203.10.76.45]:50743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbZKEEkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 23:40:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Greg KH <gregkh@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: virtio-net: new section mismatch warning. revert patch?
Date: Thu, 5 Nov 2009 15:10:53 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alex Williamson <alex.williamson@hp.com>,
       Mark McLoughlin <markmc@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091104141729.GA27288@redhat.com>
In-Reply-To: <20091104141729.GA27288@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911051510.54163.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 12:47:30 am Michael S. Tsirkin wrote:
> With v2.6.32-rcX I started getting section mismatch warnings for
> virtio_net.
> make with CONFIG_DEBUG_SECTION_MISMATCH=y shows:
> 
> WARNING: drivers/net/virtio_net.o(.data+0x90): Section mismatch in
> reference from the variable virtio_net to the function
> .devexit.text:virtnet_remove()                                                                    
> The variable virtio_net references                                                                            
> the function __devexit virtnet_remove()                                                                       
> If the reference is valid then annotate the                                                                   
> variable with __exit* (see linux/init.h) or name the variable:                                                
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,                                  
> 
> virtnet_remove was converted to devexit by this commit:
> 
> 	commit 3d1285beff2e8467b8c3884d83b7a91a99aa9fcd
> 	Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 	Date:   Wed Sep 30 22:28:34 2009 +0000
> 
> 	    move virtnet_remove to .devexit.text
> 
> We didn't have these warnings in v2.6.31, so this is a regression.
> revert?

No, just rename "virtio_net" to "virtio_net_driver".  Meanwhile, ignore it.
It's worked well for me so far.

Uwe: I apologize for accepting your patches.  I will be more careful in
future.

Cheers,
Rusty.
