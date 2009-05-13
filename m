Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbZEMXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbZEMXSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZEMXSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:18:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZEMXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:18:05 -0400
Date: Wed, 13 May 2009 16:17:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, ieidus@redhat.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-Id: <20090513161739.d801ab67.akpm@linux-foundation.org>
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
> 
> Ksm is used for cases where using fork() is not suitable,
> one of this cases is where the pages of the application keep changing
> dynamicly and the application cannot know in advance what pages are
> going to be identical.
> 
> Ksm works by walking over the memory pages of the applications it
> scan in order to find identical pages.
> It uses a two sorted data strctures called stable and unstable trees
> to find in effective way the identical pages.
> 
> When ksm finds two identical pages, it marks them as readonly and merges
> them into single one page,
> after the pages are marked as readonly and merged into one page, linux
> will treat this pages as normal copy_on_write pages and will fork them
> when write access will happen to them.
> 
> Ksm scan just memory areas that were registred to be scanned by it.
> 
> ...
> +	copy_user_highpage(kpage, page1, addr1, vma);
> ...

Breaks ppc64 allmodcofnig because that architecture doesn't export its
copy_user_page() to modules.

Architectures are inconsistent about this.  x86 _does_ export it,
because it bounces it to the exported copy_page().

So can I ask that you sit down and work out upon which architectures it
really makes sense to offer KSM?  Disallow the others in Kconfig and
arrange for copy_user_highpage() to be available on the allowed architectures?

Thanks.
