Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZIRRaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZIRRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZIRRaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:30:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58722
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbZIRRaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:30:07 -0400
Date: Fri, 18 Sep 2009 10:30:25 -0700 (PDT)
Message-Id: <20090918.103025.100709991.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64 pcpu failures...
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AB34722.7050105@kernel.org>
References: <20090917.221807.208354411.davem@davemloft.net>
	<20090917.223723.07032792.davem@davemloft.net>
	<4AB34722.7050105@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Sep 2009 17:38:58 +0900

> Yes, this would be the result of the new congruent sparse allocator.
> Heh... I didn't really expect that WARN_ON() to actually trigger.
> What it means is that the farthest percpu units were too far to fit
> into vmalloc area so percpu chunks couldn't be allocated in the
> vmalloc area.  Checking... vmalloc area on sparc64 is only 4G so yeap
> that is entirely possible.
> 
> Hmmm... the congruent sparse allocator assumes vmalloc area to be
> larger with some margin than the farthest physical memory nodes.  On
> x86, powerpc and ia64, this holds with sufficient margin.  Would it be
> possible to modify sparc64 memory layout so that the assumption can be
> satisfied?  If that's not possible, going back to lpage is an option
> but in many ways congruent sparse allocator is better.

I'll think about this, thanks.
