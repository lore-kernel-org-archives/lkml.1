Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZDWHYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZDWHYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZDWHYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:24:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33661
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbZDWHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:24:11 -0400
Date: Thu, 23 Apr 2009 00:24:03 -0700 (PDT)
Message-Id: <20090423.002403.74400050.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, alex.williamson@hp.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: upstream tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090423163847.200f227e.sfr@canb.auug.org.au>
References: <20090423163847.200f227e.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 23 Apr 2009 16:38:47 +1000

> Today's linux-next build (powerpc allyesconfig gcc4.4.0) produced these
> warnings:
> 
> drivers/net/virtio_net.c: In function 'virnet_vlan_rx_add_vid':
> include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in this function
> drivers/net/virtio_net.c:746: note: 'sg' was declared here
> drivers/net/virtio_net.c: In function 'virnet_vlan_rx_kill_vid':
> include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in this function
> drivers/net/virtio_net.c:758: note: 'sg' was declared here
> 
> in each case, sg is uninitialised when its address is passed to
> sg_set_buf() which passes it to gs_set_page() which passes it to
> sg_assign_page() which dereferences it (to use ->page_link).

I wonder if this is a side effect of changes that went in via Rusty's
tree?  I don't remember touching this driver in a while.

