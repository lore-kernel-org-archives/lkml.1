Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZDBEbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZDBEbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZDBEbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:31:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbZDBEbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:31:23 -0400
Date: Wed, 01 Apr 2009 21:31:12 -0700 (PDT)
Message-Id: <20090401.213112.96144152.davem@davemloft.net>
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: More problems in setup_pcpu_remap()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The way this code is currently designed, it can exhaust all of the
VMALLOC address space on both x86 and x86_64, and then some.

It allocates PMD_SIZE * num_possible_cpus() of vmalloc space.

PMD_SIZE is 2MB, num_possible_cpus() can be up to 4096....
which can easily exceed (VMALLOC_END - VMALLOC_START)

Initially I had set out to implement sparc64 support for the new
per-cpu stuff, but it looks like I'm stuck finding bugs in the x86
implementation instead :-)
