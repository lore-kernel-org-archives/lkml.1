Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZAKD6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZAKD6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZAKD6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:58:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:40400 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZAKD6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:58:40 -0500
Date: Sun, 11 Jan 2009 12:58:03 +0900
To: Ian.Campbell@citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, jj@chaosbits.net, weiyi.huang@gmail.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 1/2] swiotlb: range_needs_mapping should take a
 physical address.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
References: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
	<1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
	<1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090111125438G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jan 2009 18:32:09 +0000
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> The swiotlb_arch_range_needs_mapping() hook should take a physical
> address rather than a virtual address in order to support highmem pages.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  arch/x86/kernel/pci-swiotlb_64.c |    2 +-
>  include/linux/swiotlb.h          |    2 +-
>  lib/swiotlb.c                    |   10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)

Yeah, using a cpu address here doesn't make sense. I wondered what you
were trying with a cpu address when reading your original patch.

Might be more clean to unify address_needs_mapping and
range_needs_mapping. I guess that I need to see what Xen wants to do
with this though.

