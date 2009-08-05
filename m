Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZHEVVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZHEVVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZHEVVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:21:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53230 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZHEVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:21:05 -0400
Date: Wed, 5 Aug 2009 22:19:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org, hpa@zytor.com,
       alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 2/6] include/linux/unaligned/{l,b}e_byteshift.h: Fix
	usage for compressed kernels
Message-ID: <20090805211929.GB9303@n2100.arm.linux.org.uk>
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <20090804155550.3203f5f4.akpm@linux-foundation.org> <20090805092956.GD5854@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805092956.GD5854@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 11:29:56AM +0200, Albin Tonnerre wrote:
> linux/kernel.h brings at least:
> extern int console_printk[];
> extern const char hex_asc[];
> which causes errors at link-time as they are not available when
> compiling the pre-boot environement. There are also a few others:

To be clear, for Andrew's benefit, the reason this happens is because
we disable the 'static' when building on ARM - this is because we build
the decompressor with -fPIC, so we can relocate _just_ the data segment
without writing at all to the text segment.

This is so that we can flash the compressed image into read only memory
and have the kernel boot directly from that memory, without having to
have an expensive and unnecessary copy.

Having static data and functions causes complications which make this
impossible to otherwise achieve.  I don't remember the details, I'm not
an expert on the ARM shared library stuff.
