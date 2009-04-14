Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZDNWPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZDNWPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZDNWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:15:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbZDNWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:15:28 -0400
Date: Tue, 14 Apr 2009 15:09:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com,
       ieidus@redhat.com
Subject: Re: [PATCH 3/4] add replace_page(): change the page pte is pointing
 to.
Message-Id: <20090414150925.58b464f7.akpm@linux-foundation.org>
In-Reply-To: <1239249521-5013-4-git-send-email-ieidus@redhat.com>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com>
	<1239249521-5013-2-git-send-email-ieidus@redhat.com>
	<1239249521-5013-3-git-send-email-ieidus@redhat.com>
	<1239249521-5013-4-git-send-email-ieidus@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Apr 2009 06:58:40 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> replace_page() allow changing the mapping of pte from one physical page
> into diffrent physical page.

At a high level, this is very similar to what page migration does.  Yet
this implementation shares nothing with the page migration code.

Can this situation be improved?

> this function is working by removing oldpage from the rmap and calling
> put_page on it, and by setting the pte to point into newpage and by
> inserting it to the rmap using page_add_file_rmap().
> 
> note: newpage must be non anonymous page, the reason for this is:
> replace_page() is built to allow mapping one page into more than one
> virtual addresses, the mapping of this page can happen in diffrent
> offsets inside each vma, and therefore we cannot trust the page->index
> anymore.
> 
> the side effect of this issue is that newpage cannot be anything but
> kernel allocated page that is not swappable.
> 

