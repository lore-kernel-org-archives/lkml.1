Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbZHEJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbZHEJTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933887AbZHEJTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:19:34 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:48831 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbZHEJTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:19:33 -0400
Date: Wed, 5 Aug 2009 11:19:21 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sam@ravnborg.org, hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 3/6] Add support for LZO-compressed kernels
Message-ID: <20090805091813.GC5854@laptop>
References: <20090731093107.GA29704@merkur.ravnborg.org>
 <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com>
 <20090804160043.82b256d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090804160043.82b256d8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 04:00:43PM -0700, Andrew Morton wrote :
> On Mon,  3 Aug 2009 16:58:18 +0200
> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> > This is the first part of the lzo patch
> > The lzo compressor is worse than gzip at compression, but faster at
> > extraction. Here are some figures for an ARM board I'm working on:

> > Uncompressed size: 3.24Mo
> > gzip  1.61Mo 0.72s
> > lzo   1.75Mo 0.48s

> > So for a compression ratio that is still relatively close to gzip, it's
> > much faster to extract, at least in that case.

> Is 3.2Mb a typical kernel size for small systems?  It sounds large.

This one actually embeds an initramfs which accounts for about half of the size.

> > +#ifdef STATIC

> What is this STATIC thing for?

That's what is currently used to test whether you're compiling the pre-boot
environment. eg. include/linux/decompress/mm.h uses this to determine whether it
should provide a malloc() implementation or simply #define malloc(a) kmalloc(a, GFP_KERNEL),
and a lot of similar things

-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
