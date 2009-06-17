Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbZFQRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbZFQRe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbZFQReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:34:36 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56101 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759791AbZFQRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:34:34 -0400
Date: Wed, 17 Jun 2009 13:34:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Dimitri Sivanich <sivanich@sgi.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mel@csn.ul.ie,
       nickpiggin@yahoo.com.au, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: + page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
 added to -mm tree
In-Reply-To: <20090617140053.GB32637@sgi.com>
Message-ID: <alpine.DEB.1.10.0906171331210.1695@gentwo.org>
References: <200906161901.n5GJ1osY026940@imap1.linux-foundation.org> <20090617091040.99BB.A69D9226@jp.fujitsu.com> <20090617140053.GB32637@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Dimitri Sivanich wrote:

> > pcp is only protected local_irq_save(), not spin lock. it assume
> > each cpu have different own pcp. but this patch break this assumption.
> > Now, we can share boot_pageset by multiple cpus.
> >
>
> I'm not quite understanding what you mean.
>
> Prior to the cpu going down, each unpopulated zone pointed to the boot_pageset (per_cpu_pageset) for it's cpu (it's array element), so things had been set up this way already.  I could be missing something, but am not sure why restoring this would be a risk?

The boot_pageset is supposed to be per cpu and this patch preserves it.

However, all zones for a cpu have just a single boot pageset. Maybe that
was what threw off Kosaki?

