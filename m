Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbXJOWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbXJOWtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXJOWtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:49:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41200 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbXJOWtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:49:01 -0400
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags
	interfaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <11.290135367@selenic.com>
References: <11.290135367@selenic.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 15:48:33 -0700
Message-Id: <1192488513.6118.98.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
> From: Matt Mackall <mpm@selenic.com>
> 
> This makes physical page map counts available to userspace. Together
> with /proc/pid/pagemap and /proc/pid/clear_refs, this can be used to
> monitor memory usage on a per-page basis.
...
> +       while (count > 0) {
> +               ppage = pfn_to_page(pfn++);
> +               if (!ppage)
> +                       pflags = 0;
> +               else
> +                       pflags = ppage->flags;
> +

This one makes me worry a little bit.  Are we sure that this won't
expose a wee bit too much to userspace?

I can see it making sense to clear the page refs, then inspect whether
the page has been referenced again.  But, I worry that people are going
to start doing things like read NUMA, SPARSEMEM, or other internal
information out of these.

I've seen quite a few patches lately that do creative things with these
*cough*clameter*cough*, and I worry that they're too fluid to get
exposed to userspace.

Could we just have /proc/kpagereferenced?  Is there a legitimate need
for other flags to be visible?
 
-- Dave

