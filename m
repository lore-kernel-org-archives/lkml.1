Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbZFVNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbZFVNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZFVNp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:45:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51458 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751844AbZFVNpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:45:55 -0400
Date: Mon, 22 Jun 2009 08:45:57 -0500
From: Robin Holt <holt@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
Message-ID: <20090622134557.GC7084@sgi.com>
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A39E2CF.80901@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To avoid this problem, This patch inserts ia64_set_psr_mc() before the
> deadloop to mask MCA/INIT on cpus going to be frozen.  I confirmed that
> weird log like above are disappeared after applying this patch.

Please do not do this.  Turning off MCA/INIT is just a horrible idea.
When your code has a bug, the INIT of the cpu is the only tool we have
to find out what it is doing short of putting special hardware onto the
machine and trying to track it down.

Without thinking about it, I have a gut feeling there must be some way
to at least allow the MCA/INIT to make it through PROM and be delivered
to the OS.  From there the OS should be able to sort out a way to handle
kdump and MCAs received during a kdump.

Thanks,
Robin
