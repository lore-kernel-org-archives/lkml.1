Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZDBEwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZDBEwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZDBEwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:52:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37914
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbZDBEwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:52:44 -0400
Date: Wed, 01 Apr 2009 21:52:33 -0700 (PDT)
Message-Id: <20090401.215233.134215150.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: More problems in setup_pcpu_remap()
From: David Miller <davem@davemloft.net>
In-Reply-To: <49D44251.4000606@kernel.org>
References: <20090401.213112.96144152.davem@davemloft.net>
	<49D44251.4000606@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 02 Apr 2009 13:42:57 +0900

> I guess we'll have to put a cap on how high possible cpus can be for
> remap allocator.  e.g. if single chunk size is over 20% of the whole
> vmalloc area, don't use remap.  Does anyone have a good random %
> number on mind?

I would suggest instead to rethink what this code is doing.

It would make more sense to carve up 2MB chunks into some-power-of-2
pieces and use that as the unit size.

You could retain the NUMA goals of this function, as well as the
ability to be using 2MB pages in the TLBs.

And consider that if the dynamic allocation part of this code triggers
even once, you'll end up eating twice as much VMALLOC space.

Using 2MB per cpu is just rediculious, and really not even necessary.
