Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZDZJV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZDZJV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZDZJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:21:18 -0400
Received: from verein.lst.de ([213.95.11.210]:60609 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZDZJVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:21:17 -0400
Date: Sun, 26 Apr 2009 11:21:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-arch@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: USE_ELF_CORE_DUMP?
Message-ID: <20090426092103.GB8207@lst.de>
References: <20090423183331.GA19899@lst.de> <49F16786.7010401@petalogix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F16786.7010401@petalogix.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 09:17:26AM +0200, Michal Simek wrote:
> Christoph Hellwig wrote:
> > Currently all architectures but microblaze unconditionally define
> > USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
> > me, so can we just kill this ifdef and make sure we are the same
> > everywhere?
> >   
> Where did you find it?
> I haven't seen in in mainline (noMMU kernel). It is in my MMU patches
> which I want to send for review soon.

USE_ELF_CORE_DUMP is defined in arch/x86/include/*/elf.h (or sometimes
elf_{32,64}.h) on all architectures but microblaze.

> For noMMU I use CONFIG_BINFMT_FLAT (binfmt_flat.c) where I don't need
> USE_ELF_CORE_DUMP
> For MMU I use CONFIG_BINFMT_ELF (binfmt_elf.c) where USE_ELF_CORE_DUMP
> make sense to me.

USE_ELF_CORE_DUMP only comes into play if CONFIG_ELF_CORE is set, so in
the mmu example above.  These two are in fact always checked together,
so not setting USE_ELF_CORE_DUMP is an obscure way to disable elf core
dumps despite CONFIG_ELF_CORE being set.

