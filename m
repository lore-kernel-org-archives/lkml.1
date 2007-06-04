Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXFDSzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXFDSzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759163AbXFDSy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:54:58 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35767 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044AbXFDSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:54:57 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 4 Jun 2007 14:53:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Lameter <clameter@sgi.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __get_free_pages:  can GFP_DMA omit GFP_KERNEL and GFP_ATOMIC?
In-Reply-To: <Pine.LNX.4.64.0706041143520.24412@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706041449470.3148@localhost.localdomain>
References: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
 <Pine.LNX.4.64.0706041143520.24412@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Christoph Lameter wrote:

> On Sun, 3 Jun 2007, Robert P. J. Day wrote:
>
> >   first, can a call to __get_free_pages to allocate DMA-able
> > memory omit specifying either of GFP_KERNEL or GFP_ATOMIC?
> > love's book on kernel development strongly suggests you need to
> > specify one or the other, but there are a few instances in the
> > tree like this:
>
> Sure that seems to be equivalent to GFP_ATOMIC with no access to
> emergency pool memory.
>
> >   and, second, i only noticed this as i was going to submit a
> > short patch to replace __get_free_pages calls for DMA-able memory
> > with the existing equivalent macro __get_dma_pages.  is that still
> > considered a worthwhile cleanup?  there's not that many examples
> > of it, and it would just make things consistent.
>
> Sure.

all right, then some of those __get_free_pages() calls would translate
to calls of the form __get_dma_pages(0, ...) -- is that what you're
saying?  or would it be equivalent and preferable to put GFP_ATOMIC in
there just so it looks not so weird?

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
