Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYLCJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYLCJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYLCJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:03:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYLCJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:03:26 -0500
Subject: Re: [PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081203004120.460166ac.akpm@linux-foundation.org>
References: <20081114234131.GA28559@x200.localdomain>
	 <1226747692.3687.285.camel@macbook.infradead.org>
	 <20081121015559.GA4478@x200.localdomain>
	 <20081203004120.460166ac.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 09:03:21 +0000
Message-Id: <1228295002.27314.6.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 00:41 -0800, Andrew Morton wrote:
> The changelog is too crappy for me.  Why did that error occur, and how
> does the patch fix it?

Well, you repeated the explanation of what's wrong -- although I don't
see how it actually causes an _error_; it works here.

The problem is that the MODULE_DEVICE_TABLE(dmi, foo) line expands to...

extern const struct dmi_device_id __mod_dmi_device_table
      __attribute__ ((unused, alias("foo")));

And 'struct dmi_device_id' doesn't exist -- what we have is 'struct
dmi_system_id'.

In practice, this doesn't seem to matter because we never ask the
compiler to look _inside_ that struct -- it's just like a forward
declaration of 'struct foo' and then using pointers to it.

But it looks like Alexey's managed to find a way to actually make a
compiler barf on it, so that increases the motivation to fix it
promptly...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

