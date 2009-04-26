Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZDZMX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZDZMX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZDZMXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:23:17 -0400
Received: from ozlabs.org ([203.10.76.45]:56667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZDZMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:23:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: linux-next: upstream tree build warnings
Date: Sun, 26 Apr 2009 21:53:10 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, alex.williamson@hp.com,
       linux-kernel@vger.kernel.org
References: <20090423163847.200f227e.sfr@canb.auug.org.au> <20090423.002403.74400050.davem@davemloft.net>
In-Reply-To: <20090423.002403.74400050.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904262153.10948.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 04:54:03 pm David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 23 Apr 2009 16:38:47 +1000
> 
> > Today's linux-next build (powerpc allyesconfig gcc4.4.0) produced these
> > warnings:
> > 
> > drivers/net/virtio_net.c: In function 'virnet_vlan_rx_add_vid':
> > include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in this function
> > drivers/net/virtio_net.c:746: note: 'sg' was declared here
> > drivers/net/virtio_net.c: In function 'virnet_vlan_rx_kill_vid':
> > include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in this function
> > drivers/net/virtio_net.c:758: note: 'sg' was declared here
> > 
> > in each case, sg is uninitialised when its address is passed to
> > sg_set_buf() which passes it to gs_set_page() which passes it to
> > sg_assign_page() which dereferences it (to use ->page_link).
> 
> I wonder if this is a side effect of changes that went in via Rusty's
> tree?  I don't remember touching this driver in a while.

AFAICT gcc is right: it should be sg_init_one().

It doesn't currently *matter*, since no virtio add_buf implementation
does that chained-sg crap (I had a patch once, but it made me barf) and
so the uninitialized lower three bits are ignored.

Alex, if you agree, patch welcome...
Rusty.
