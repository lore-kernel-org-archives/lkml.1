Return-Path: <linux-kernel-owner+w=401wt.eu-S1161519AbXDWMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161519AbXDWMeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161520AbXDWMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:34:37 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:43997 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161519AbXDWMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:34:36 -0400
Message-Id: <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Mon, 23 Apr 2007 21:34:07 +0900
To: Hugh Dickins <hugh@veritas.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
 <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 >No.  The PG_lru flag bit is just one bit amongst many others:
 >what of concurrent operations changing other bits in that same
 >unsigned long e.g. trying to lock the page by setting PG_locked?
 >There are some places where such micro-optimizations can be made
 >(typically while first allocating the page); but in general, no.

In i386 and x86_64, btsl is used to change page flag. In this case, if btsl 
without lock prefix
set PG_locked and PG_lru flag concurrently, does only one operation
succeed ?

