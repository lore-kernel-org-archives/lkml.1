Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYCBFSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYCBFSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYCBFS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 00:18:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYCBFS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 00:18:26 -0500
Date: Sun, 2 Mar 2008 00:18:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080302051810.GA31681@infradead.org>
References: <20080227222103.673194000@chello.nl> <1204311351.6243.130.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204311351.6243.130.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 07:55:51PM +0100, Peter Zijlstra wrote:
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/irq.h |    9 ++
>  kernel/cpuset.c     |  160 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq/manage.c |   19 ++++++
>  3 files changed, 188 insertions(+)

linux/irq.h must not be included in generic code, it's actually more
and asm-generic/hw_irq.h.  Please restructure the code so that the
cpuset code calls into an arch interface which will then be implemented
by arch code (which in most cases will be genirq, the other can be left
stubbed out for now)

