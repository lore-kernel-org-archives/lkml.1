Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbZINU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbZINU22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbZINU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:28:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:41304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829AbZINU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:28:26 -0400
Date: Mon, 14 Sep 2009 22:31:58 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       peterz@infradead.org, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-ID: <20090914223158.60ea33f8@infradead.org>
In-Reply-To: <20090914004301.105196cc.akpm@linux-foundation.org>
References: <20090911174019.1ed02737@infradead.org>
	<20090914004301.105196cc.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 00:43:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> static DEFINE_PER_CPU(struct menu_device, menu_devices);
> 
> in both menu.c and menu-tng.c.
> 
> Despite the `static', the percpu changes in
> 
> commit 7c756e6e19e71f0327760d8955f7077118ebb2b1
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Wed Jun 24 15:13:50 2009 +0900
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Wed Jun 24 15:13:50 2009 +0900
> 
>     percpu: implement optional weak percpu definitions
> 
> are emitting global symbol derived from `menu_devices' and they clash.
> 
> 
> I'll rename menu_devices to fix that up, but we have a problem...

I would consider "static" not working a problem...
yes here it's easy to fix, but it's not nice if you can't make .c file
private..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
