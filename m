Return-Path: <linux-kernel-owner+w=401wt.eu-S1766679AbXEBTaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766679AbXEBTaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766637AbXEBTaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:30:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766679AbXEBTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:30:27 -0400
Date: Wed, 2 May 2007 20:30:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] firewire: char device interface
Message-ID: <20070502193026.GC1248@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 02:17:26PM +0200, Stefan Richter wrote:
> +#include <asm/ioctl.h>
> +#include <asm/types.h>

Always use the <linux/ versions.

> +struct fw_cdev_get_info {
> +	/* The version field is just a running serial number.  We
> +	 * never break backwards compatibility.  Userspace passes in
> +	 * the version it expects and the kernel passes back the
> +	 * highest version it can provide.  Even if the structs in
> +	 * this interface are extended in a later version, the kernel
> +	 * will not copy back more data than what was present in the
> +	 * interface version userspace expects. */
> +	__u32 version;

Please don't even try to build interfaces this complicated.  If your
current interface needs changes at some point just introduce new ioctls.

