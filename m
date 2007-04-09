Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbXDISsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbXDISsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbXDISsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:48:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbXDISsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:48:35 -0400
Date: Mon, 9 Apr 2007 11:48:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
Message-Id: <20070409114827.d3cbf705.akpm@linux-foundation.org>
In-Reply-To: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Apr 2007 11:25:09 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On x86_64 this cuts allocation overhead for page table pages down to
> a fraction (kernel compile / editing load. TSC based measurement
> of times spend in each function):
> 
> no quicklist
> 
> pte_alloc               1569048 4.3s(401ns/2.7us/179.7us)
> pmd_alloc                780988 2.1s(337ns/2.7us/86.1us)
> pud_alloc                780072 2.2s(424ns/2.8us/300.6us)
> pgd_alloc                260022 1s(920ns/4us/263.1us)
> 
> quicklist:
> 
> pte_alloc                452436 573.4ms(8ns/1.3us/121.1us)
> pmd_alloc                196204 174.5ms(7ns/889ns/46.1us)
> pud_alloc                195688 172.4ms(7ns/881ns/151.3us)
> pgd_alloc                 65228 9.8ms(8ns/150ns/6.1us)
> 
> pgd allocations are the most complex and there we see the most dramatic
> improvement (may be we can cut down the amount of pgds cached somewhat?).
> But even the pte allocations still see a doubling of performance.

Was there any observeable change in overall runtime?

What are the numbers in parentheses?
