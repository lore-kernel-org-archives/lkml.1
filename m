Return-Path: <linux-kernel-owner+w=401wt.eu-S1423289AbXDYIti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423289AbXDYIti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423306AbXDYIti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:49:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423313AbXDYItg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:49:36 -0400
Date: Wed, 25 Apr 2007 04:49:31 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Big reserved mappings on x86_64
Message-ID: <20070425084931.GC355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <Pine.LNX.4.61.0704251035480.19711@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704251035480.19711@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 10:42:20AM +0200, Jan Engelhardt wrote:
> I actually took a look at `pmap $$`, which reveals that a lot of shared 
> libraries map 2044K or 2048K unreadable-unwritable-private 
> mappings...for _what_ purpose?
> 
> 10:37 opteron:~ > pmap $$
> 4403: bash
> START       SIZE     RSS   DIRTY PERM MAPPING
> 2ae6cca70000    212K    172K      0K r-xp /lib64/libreadline.so.5.2
> 2ae6ccaa5000   2044K      0K      0K ---p /lib64/libreadline.so.5.2 <--
> 2ae6ccca4000      4K      4K      4K r--p /lib64/libreadline.so.5.2
> 2ae6ccca5000     28K     28K     28K rw-p /lib64/libreadline.so.5.2
> 2ae6cccac000      8K      8K      8K rw-p [anon]
> 2ae6cccae000     28K     16K      0K r-xp /lib64/libhistory.so.5.2
> 2ae6cccb5000   2048K      0K      0K ---p /lib64/libhistory.so.5.2 <--
> 2ae6cceb5000      8K      8K      8K rw-p /lib64/libhistory.so.5.2
> 2ae6cceb7000    320K    208K      0K r-xp /lib64/libncurses.so.5.5
> 2ae6ccf07000   2048K      0K      0K ---p /lib64/libncurses.so.5.5 <--
> 2ae6cd107000     48K     48K     48K r--p /lib64/libncurses.so.5.5
> 2ae6cd113000     28K     28K     28K rw-p /lib64/libncurses.so.5.5
> [...]
> 
> What could these ominous mappings be? Does anyone else see that - 
> perhaps someone with x86_64 && !(opensuse 10.2)?

While i386 only supports 4KB pages, x86_64 ELF objects ought to support
up to 2MB pages.  The gap between read-only/executable and writable segments
is intentionally mapped PROT_NONE, so that other things aren't mapped in
between the segments.

	Jakub
