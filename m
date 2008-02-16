Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYBPI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYBPI6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYBPI6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:58:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbYBPI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:57:58 -0500
Date: Sat, 16 Feb 2008 00:56:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-Id: <20080216005653.353a62dc.akpm@linux-foundation.org>
In-Reply-To: <47B6A2BE.6080201@qumranet.com>
References: <20080215064859.384203497@sgi.com>
	<20080215064932.371510599@sgi.com>
	<20080215193719.262c03a1.akpm@linux-foundation.org>
	<47B6A2BE.6080201@qumranet.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 10:45:50 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Andrew Morton wrote:
> > How important is this feature to KVM?
> >   
> 
> Very.  kvm pins pages that are referenced by the guest;

hm.  Why does it do that?

> a 64-bit guest 
> will easily pin its entire memory with the kernel map.

>  So this is 
> critical for guest swapping to actually work.

Curious.  If KVM can release guest pages at the request of this notifier so
that they can be swapped out, why can't it release them by default, and
allow swapping to proceed?

> 
> Other nice features like page migration are also enabled by this patch.
> 

We already have page migration.  Do you mean page-migration-when-using-kvm?
