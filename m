Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZD0WkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZD0WkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZD0Wjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:39:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405AbZD0Wjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:39:51 -0400
Date: Mon, 27 Apr 2009 15:34:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, ieidus@redhat.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-Id: <20090427153421.2682291f.akpm@linux-foundation.org>
In-Reply-To: <1240191366-10029-6-git-send-email-ieidus@redhat.com>
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>
	<1240191366-10029-2-git-send-email-ieidus@redhat.com>
	<1240191366-10029-3-git-send-email-ieidus@redhat.com>
	<1240191366-10029-4-git-send-email-ieidus@redhat.com>
	<1240191366-10029-5-git-send-email-ieidus@redhat.com>
	<1240191366-10029-6-git-send-email-ieidus@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 04:36:06 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> Ksm is driver that allow merging identical pages between one or more
> applications in way unvisible to the application that use it.
> Pages that are merged are marked as readonly and are COWed when any
> application try to change them.

Breaks sparc64 and probably lots of other architectures:

mm/ksm.c: In function `try_to_merge_two_pages_alloc':
mm/ksm.c:697: error: `_PAGE_RW' undeclared (first use in this function)

there should be an official arch-independent way of manipulating
vma->vm_page_prot, but I'm not immediately finding it.

An alternative (and quite inferior) "fix" would be to disable ksm on
architectures which don't implement _PAGE_RW.  That's most of them.

