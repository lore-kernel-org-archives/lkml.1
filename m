Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXKAQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXKAQ4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKAQ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:56:43 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:35280 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbXKAQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:56:42 -0400
To: a.p.zijlstra@chello.nl
CC: jdike@addtoit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <1193935886.27652.313.camel@twins> (message from Peter Zijlstra
	on Thu, 01 Nov 2007 17:51:26 +0100)
Subject: Re: per-bdi-throttling: synchronous writepage doesn't work
	correctly
References: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu> <1193935886.27652.313.camel@twins>
Message-Id: <E1IndPT-00047e-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Nov 2007 18:00:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi,
> > 
> > It looks like bdi_thresh will always be zero if filesystem does
> > synchronous writepage, resulting in very poor write performance.
> > 
> > Hostfs (UML) is one such example, but there might be others.
> > 
> > The only solution I can think of is to add a set_page_writeback();
> > end_page_writeback() pair (or some reduced variant, that only does
> > the proportions magic).  But that means auditing quite a few
> > filesystems...
> 
> Ouch...
> 
> I take it there is no other function that is shared between all these
> writeout paths which we could stick a bdi_writeout_inc(bdi) in?

No, and you can't detect it from the callers either I think.

Miklos
