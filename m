Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbZKYGwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbZKYGwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZKYGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:52:45 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36741 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZKYGwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:52:45 -0500
Date: Wed, 25 Nov 2009 15:51:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jie Zhang <jie.zhang@analog.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Message-ID: <20091125065156.GC30779@linux-sh.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <20091125061640.GB17203@shareable.org> <4B0CCE4A.5000602@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0CCE4A.5000602@analog.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 02:27:22PM +0800, Jie Zhang wrote:
> On 11/25/2009 02:16 PM, Jamie Lokier wrote:
> >Mike Frysinger wrote:
> >>From: Jie Zhang<jie.zhang@analog.com>
> >>
> >>The mmu code uses the copy_*_user_page() variants in access_process_vm()
> >>rather than copy_*_user() as the former includes an icache flush.  This is
> >>important when doing things like setting software breakpoints with gdb.
> >>So switch the nommu code over to do the same.
> >
> >Reasonable, but it's a bit subtle don't you think?
> >How about a one-line comment saying why it's using copy_*_user_page()?
> >
> >(If it was called copy_*_user_flush_icache() I wouldn't say anything,
> >but it isn't).
> >
> But I think it's well known in Linux kernel developers that 
> copy_to_user_page and copy_from_user_page should do cache flushing. It's 
> documented in Documentation/cachetlb.txt. I don't think it's necessary 
> to replicate it here.
> 
Documenting it in the changelog is sufficient I think. Platforms that
need the I-cache flush can deal with it there, and those that don't
aren't going to notice any difference regardless. The change in semantics
is subtle, but as it's bringing it in line with MMU behaviour it's not
really worth noting the fact that NOMMU behaviour used to be different
for no particular reason.

Acked-by: Paul Mundt <lethal@linux-sh.org>
