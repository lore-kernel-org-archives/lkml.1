Return-Path: <linux-kernel-owner+w=401wt.eu-S965486AbXCMJIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486AbXCMJIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965518AbXCMJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:08:36 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45860 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965486AbXCMJIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:08:35 -0400
Date: Tue, 13 Mar 2007 18:05:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/4] Generic quicklist implementation
Message-ID: <20070313090546.GA4511@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
	linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com> <20070313071330.4920.54914.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313071330.4920.54914.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:13:30AM -0700, Christoph Lameter wrote:
> --- linux-2.6.21-rc3-mm2.orig/mm/Kconfig	2007-03-12 22:49:21.000000000 -0700
> +++ linux-2.6.21-rc3-mm2/mm/Kconfig	2007-03-13 00:09:50.000000000 -0700
> @@ -220,3 +220,8 @@ config DEBUG_READAHEAD
>  
>  	  Say N for production servers.
>  
> +config QUICKLIST
> +	bool
> +	default y if NR_QUICK != 0
> +
> +

This doesn't work, and so CONFIG_QUICKLIST is always set. The NR_QUICK
thing seems a bit backwards anyways, perhaps it would make more sense to
have architectures set CONFIG_GENERIC_QUICKLIST in the same way that the
other GENERIC_xxx bits are defined, and then set NR_QUICK based off of
that. It's obviously going to be 2 or 1 for most people, and x86 seems to
be the only one that needs 2.

How about this?

--

diff --git a/mm/Kconfig b/mm/Kconfig
index 7942b33..2f20860 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -163,3 +163,8 @@ config ZONE_DMA_FLAG
 	default "0" if !ZONE_DMA
 	default "1"
 
+config NR_QUICK
+	int
+	depends on GENERIC_QUICKLIST
+	default "2" if X86
+	default "1"
