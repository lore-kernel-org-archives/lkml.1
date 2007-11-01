Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXKARYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXKARYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXKARYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:24:41 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:50260 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXKARYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:24:40 -0400
To: a.p.zijlstra@chello.nl
CC: jdike@addtoit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <1193936949.27652.321.camel@twins> (message from Peter Zijlstra
	on Thu, 01 Nov 2007 18:09:09 +0100)
Subject: Re: per-bdi-throttling: synchronous writepage doesn't work
	correctly
References: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu>
	 <1193935886.27652.313.camel@twins>
	 <E1IndPT-00047e-00@dorka.pomaz.szeredi.hu> <1193936949.27652.321.camel@twins>
Message-Id: <E1Indqb-00049a-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Nov 2007 18:28:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The page not having PG_writeback set on return is a hint, but not fool
> proof, it could be the device is just blazing fast.

Hmm, does it actually has to be foolproof though?  What will happen if
bdi_writeout_inc() is called twice for the page?  The device will get
twice the number of pages it deserves?  That's not all that bad,
especially since that is a really really fast device.

Miklos
