Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZFBEIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZFBEIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZFBEIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:08:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:41151 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZFBEIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:08:34 -0400
Date: Tue, 2 Jun 2009 13:08:07 +0900
To: ian.campbell@citrix.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       jeremy@goop.org, okir@suse.de, gregkh@suse.de, mingo@elte.hu
Subject: Re: [PATCH 11/11] swiotlb: allow initialisation with pre-allocated
 bounce-buffer
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1243870383-12954-12-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
	<1243870383-12954-12-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090602130023W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Jun 2009 13:08:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 16:33:03 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> This allows the generic swiotlb code to be used by users with unusual
> requirements for the buffer allocation by allowing them to provide
> their own swiotlb buffer.
> 
> Also:
> - swiotlb_init_with_default_size is unused so collapse into
>   swiotlb_init.
> - move declarations of swiotlb_late_init_with_default_size out of *.c
>   into linux/swiotlb.h where they belong
> - Make io_tlb_nslabs and io_tlb_overflow non-static since callers of the
>   new interface will want to access them.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Olaf Kirch <okir@suse.de>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/ia64/hp/common/hwsw_iommu.c |    3 --
>  arch/ia64/hp/common/sba_iommu.c  |    2 -
>  include/linux/swiotlb.h          |   14 ++++++++
>  lib/swiotlb.c                    |   64 +++++++++++++++++++++----------------
>  4 files changed, 50 insertions(+), 33 deletions(-)

Please tell me a pointer to Xen code to use this patch. I think that
we could have more clean interfaces.
