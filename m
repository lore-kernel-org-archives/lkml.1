Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKKSbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKKSbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYKKSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:31:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYKKSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:31:36 -0500
Date: Tue, 11 Nov 2008 10:30:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
Message-Id: <20081111103051.979aea57.akpm@linux-foundation.org>
In-Reply-To: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:21:37 +0200 Izik Eidus <ieidus@redhat.com> wrote:

> KSM is a linux driver that allows dynamicly sharing identical memory pages
> between one or more processes.
> 
> unlike tradtional page sharing that is made at the allocation of the
> memory, ksm do it dynamicly after the memory was created.
> Memory is periodically scanned; identical pages are identified and merged.
> the sharing is unnoticeable by the process that use this memory.
> (the shared pages are marked as readonly, and in case of write
> do_wp_page() take care to create new copy of the page)
> 
> this driver is very useful for KVM as in cases of runing multiple guests
> operation system of the same type, many pages are sharable.
> this driver can be useful by OpenVZ as well.

These benefits should be quantified, please.  Also any benefits to any
other workloads should be identified and quantified.

The whole approach seems wrong to me.  The kernel lost track of these
pages and then we run around post-facto trying to fix that up again. 
Please explain (for the changelog) why the kernel cannot get this right
via the usual sharing, refcounting and COWing approaches.
