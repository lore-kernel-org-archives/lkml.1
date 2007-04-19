Return-Path: <linux-kernel-owner+w=401wt.eu-S1766935AbXDSTGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766935AbXDSTGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766938AbXDSTGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:06:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52014 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766935AbXDSTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:06:43 -0400
Subject: Re: [PATCH 13/13] maps#2: Add /proc/kpagemap interface
From: Dave Hansen <hansendc@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <14.469046093@selenic.com>
References: <14.469046093@selenic.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 12:06:38 -0700
Message-Id: <1177009598.12599.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 17:03 -0500, Matt Mackall wrote:
> 
> +static ssize_t kpagemap_read(struct file *file, char __user *buf,
> +                            size_t count, loff_t *ppos)
> +{
...
> +               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> +                       ppage = pfn_to_page(pfn);
> +                       if (!ppage) {
> +                               page[i] = 0;
> +                               page[i + 1] = 0;
> +                       } else {
> +                               page[i] = ppage->flags;
> +                               page[i + 1] = atomic_read(&ppage->_count);
> +                       }
> +               } 

I think this needs a pfn_valid() check for sparse/discontig systems.  I
think we'll oops if we have holes because we don't check pfn_valid()
inside of pfn_to_page().

-- Dave

