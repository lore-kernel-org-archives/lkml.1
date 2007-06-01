Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbXFAKeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbXFAKeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbXFAKeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:34:05 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41640 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbXFAKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:34:04 -0400
To: george.krajcsovits@gmail.com
CC: linux-kernel@vger.kernel.org
In-reply-to: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
	(george.krajcsovits@gmail.com)
Subject: Re: Callchain contains impossible call
References: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
Message-Id: <E1Hu4S6-0001LJ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Jun 2007 12:33:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krajo,

> this is probably RTFM (where is this manual?), but how did I get a
> callchain on a uniprocessor
> system where there are two functions that cannot be a part of it,
> because they don't call anything ? (kfree_skbmem and __kmalloc). Also
> at the end one function call is there twice.
> 
> Seems like stack corruption, but I did try to close others out with
> spin_lock_bh. This part of the code is called from kernel traps and
> softirq for ethernet RX.

I'm not an expert, but I think you basically have two options:

 - Turn on CONFIG_FRAME_POINTER

 - Gnaw through the stack trace (from bottom to top), matching up the
   entry points with actual function calls in the assembly.  That way
   you'll see which of the entries are bogus, and which correspond to
   a real call somewhere in the trace.

Miklos
