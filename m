Return-Path: <linux-kernel-owner+w=401wt.eu-S1423051AbXD3F66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423051AbXD3F66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423054AbXD3F66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:58:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54849 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423051AbXD3F65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:58:57 -0400
Date: Sun, 29 Apr 2007 22:58:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
In-Reply-To: <20070428172939.35689110@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0704292257080.2910@schroedinger.engr.sgi.com>
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
 <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
 <20070428172939.35689110@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Alan Cox wrote:

> > > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> > >
> > >   clarification?
> > 
> > oh, i'm *aware* of the definitions of those flags, but every single
> > source i've ever read has *strongly* suggested that you don't use
> 
> I don't believe either of those is doing what the author intended 8).

Well sortof. First of all kmalloc may not even allocate a page to 
satisfy the request. If it does then we do essentially GFP_KERNEL | 
__GFP_HIGH meaning a allocation where we can sleep etc but are allowed to 
dip into the reserves.

