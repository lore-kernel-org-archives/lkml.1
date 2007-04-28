Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXD1PFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXD1PFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXD1PFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:05:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46631 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXD1PFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:05:48 -0400
Subject: RE: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
	time?
From: Arjan van de Ven <arjan@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
	 <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 28 Apr 2007 08:03:42 -0700
Message-Id: <1177772622.3477.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> >
> >   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
> > were mutually exclusive when it came to calling kmalloc(), at least
> > based on everything i'd read.  so i'm not sure how to interpret the
> > following:
> >
> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> >
> >   clarification?
> 
> oh, i'm *aware* of the definitions of those flags, but every single
> source i've ever read has *strongly* suggested that you don't use
> those two flags together so i was surprised to see those combinations.
> (as an example, love's kernel book, p. 192, shows a table of valid
> combinations of flags to use, but doesn't mention the one above.)
> 
> and, on the other hand, if they *are* legal to use together, i guess
> i'm kind of surprised that there would be only two instances of it.

it's not legal to use the combo; you have found yourself a very genuine
bug here! Good spotting!


