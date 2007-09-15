Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXIOOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXIOOBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbXIOOBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:01:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbXIOOBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:01:19 -0400
Date: Sat, 15 Sep 2007 10:01:06 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: increase AT_VECTOR_SIZE to terminate saved_auxv properly
Message-ID: <20070915140106.GA7129@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070914110057.GA10088@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914110057.GA10088@aepfle.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 01:00:57PM +0200, Olaf Hering wrote:
> include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.
> fs/binfmt_elf.c has 14 unconditional NEW_AUX_ENT entries and 2
> conditional NEW_AUX_ENT entries.
> So in the worst case, saved_auxv does not get an AT_NULL entry at the
> end.
> 
> Is an AT_NULL entry required or must userspace use the AT_VECTOR_SIZE
> to not loop past the end of the array?

Of course it is required, AT_VECTOR_SIZE is a kernel implementation detail.

> If AT_NULL is required, AT_VECTOR_SIZE should be changed from 44 to 46.

No, it should be computed instead from the number of target independent aux
vector pairs and then from an per-arch macro which says how many arch
specific aux vector pairs are needed.

	Jakub
