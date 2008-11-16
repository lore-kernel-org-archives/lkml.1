Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYKPEwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYKPEwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYKPEwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:52:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:40671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYKPEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:52:03 -0500
Date: Sat, 15 Nov 2008 20:52:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-ID: <20081115205229.765f7ee3@infradead.org>
In-Reply-To: <491FA28B.2070003@cn.fujitsu.com>
References: <491FA28B.2070003@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 12:33:15 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> some subsystem needs vmalloc() when required memory is large.
> but current kernel has not APIs for this requirement.
> this patch introduces simple_malloc() and simple_free().

Hi

I kinda really don't like this approach. vmalloc() (and especially,
vfree()) is a really expensive operation, and vmalloc()'d memory is
also slower (due to tlb pressure). Realistically, people should try hard
to use small datastructure instead....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
