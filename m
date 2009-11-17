Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZKQK1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZKQK1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZKQK1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:27:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45899 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087AbZKQK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:27:20 -0500
Date: Tue, 17 Nov 2009 10:29:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
Message-ID: <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091117161711.3DDA.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	<20091117161711.3DDA.A69D9226@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 16:17:50 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.

So now what happens if we are paging and all our memory is tied up for
writeback to a device or CIFS etc which can no longer allocate the memory
to complete the write out so the MM can reclaim ?

Am I missing something or is this patch set not addressing the case where
the writeback thread needs to inherit PF_MEMALLOC somehow (at least for
the I/O in question and those blocking it)

Alan
