Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbZKNMwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbZKNMwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 07:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZKNMwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 07:52:19 -0500
Received: from sh.osrg.net ([192.16.179.4]:35839 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZKNMwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 07:52:18 -0500
Date: Sat, 14 Nov 2009 21:50:56 +0900
To: hannes@cmpxchg.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       chrisw@sous-sol.org, wmw2@infradead.org, joerg.roedel@amd.com,
       muli@il.ibm.com, akpm@linux-foundation.org, tj@kernel.org
Subject: Re: [PATCH -v2 6/9] bootmem: add free_bootmem_late
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091110120053.GA14940@cmpxchg.org>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20091110120053.GA14940@cmpxchg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091114215041W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 21:50:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing,

On Tue, 10 Nov 2009 13:00:53 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> I find it a bit weird that free_all_bootmem() callers have to take
> care of totalram_pages while this function does the accounting on its
> own.

Ah, it might be consistent to make the callers take care of
totalram_pages like free_all_bootmem.


> And I think the function is more logically placed right below
> free_bootmem(), like you did in the header.

However, if we do the above, we have:

unsigned long free_bootmem_late(unsigned long addr, unsigned long
size)

Which looks inconsistent a bit with free_bootmem()?
