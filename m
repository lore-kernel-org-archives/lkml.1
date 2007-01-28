Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbXA1Igt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbXA1Igt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbXA1Igt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 03:36:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47812 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbXA1Igs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 03:36:48 -0500
Date: Sun, 28 Jan 2007 08:36:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AGPGART compat ioctl
Message-ID: <20070128083644.GA8677@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Zwane Mwaikambo <zwane@infradead.org>,
	Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701271403420.1379@montezuma.fsmlabs.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 07:28:07PM -0800, Zwane Mwaikambo wrote:
> --- linux-2.6.20-rc4-mm1/include/linux/agpgart.h	27 Jan 2007 22:04:06 -0000	1.1.1.1
> +++ linux-2.6.20-rc4-mm1/include/linux/agpgart.h	27 Jan 2007 22:41:23 -0000
> @@ -114,6 +114,67 @@ typedef struct _agp_unbind {
>  
>  #define AGPGART_MINOR 175
>  
> +#ifdef CONFIG_COMPAT
> +#include <linux/compat.h>

I don't think this should be in public headers.  I'd rather have all
declarations and code for compat ioctl handling in a single file,
e.g. drivers/char/agp/compat_ioctl.c

> +#ifdef CONFIG_COMPAT
> +static int compat_agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)

Please make sure this doesn't overflow 80 characters per line.

