Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZI2MhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZI2MhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZI2MhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:37:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:37945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZI2MhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:37:00 -0400
Date: Tue, 29 Sep 2009 14:37:29 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: GFP_NOWAIT and GFP_NOMEMALLOC
Message-ID: <20090929143729.5af8e1f8@infradead.org>
In-Reply-To: <f22d86810909290516l4cdda2bav3588cc5f7d1f2f65@mail.gmail.com>
References: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
	<20090929135925.50ac88bf@infradead.org>
	<f22d86810909290516l4cdda2bav3588cc5f7d1f2f65@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 17:46:35 +0530
"Leonidas ." <leonidas137@gmail.com> wrote:
> 
> The module is going to be a profiling module and the user module which
> is under profiling
> will call the apis which I am exporting. My apis will collect certain
> data from point

(I assume you are aware of 'perf' and such)


> But frankly, I am not very familiar with Linux kernel apis yet hence
> have resorted to
> using a tree data structure for the first cut where I allocate memory
> as needed depending on the context I am executing in. To optimize a
> bit, I do not free my memory
> till some threshold is reached.
> 
> Some questions here:
> 
> 1. GFP_NOWAIT as in kmalloc(size, GFP_KERNEL | GFPNOWAIT)?
> 
> or
> 
> kmalloc(size, GFP_NOWAIT), I know this one is a dumb one.

don't do GFP_KERNEL |

because that makes it basically equivalent to GFP_KERNEL, which is a
sleeping version.

> 
> 2. Any reference for the mempool kind of implementation mentioned
> above?

there's mm/mempool.c..

as a general suggestion I would say "look at perf, and see if you can
build on that, or borrow from it"...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
