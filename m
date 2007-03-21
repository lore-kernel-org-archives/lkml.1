Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXCUWR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXCUWR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965197AbXCUWR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:17:59 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:36426 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194AbXCUWR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:17:57 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17921.44824.669978.639090@gargle.gargle.HOWL>
Date: Thu, 22 Mar 2007 01:18:00 +0300
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
In-Reply-To: <4601586E.302@redhat.com>
References: <46005B4A.6050307@redhat.com>
	<17920.61568.770999.626623@gargle.gargle.HOWL>
	<460115D9.7030806@redhat.com>
	<17921.7074.900919.784218@gargle.gargle.HOWL>
	<46011E8F.2000109@redhat.com>
	<46011EF6.3040704@redhat.com>
	<17921.20299.7899.527765@gargle.gargle.HOWL>
	<4601586E.302@redhat.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000531 e1fc316a905a08fcca87d3f87ae25827
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel writes:
 > Nikita Danilov wrote:
 > 
 > > Generally speaking, multi-queue replacement mechanisms were tried in the
 > > past, and they all suffer from the common drawback: once scanning rate
 > > is different for different queues, so is the notion of "hotness",
 > > measured by scanner. As a result multi-queue scanner fails to capture
 > > working set properly.
 > 
 > You realize that the current "single" queue in the 2.6 kernel
 > has this problem in a much worse way: when swappiness is low
 > and the kernel does not want to reclaim mapped pages, it will
 > randomly rotate those pages around the list.

Agree. Some time ago I tried to solve this very problem with
dont-rotate-active-list patch
(http://linuxhacker.ru/~nikita/patches/2.6.12-rc6/2005.06.11/vm_03-dont-rotate-active-list.patch),
but it had problems on its own.

 > 
 > In addition, the referenced bit on unmapped page cache pages
 > was ignored completely, making it impossible for the VM to
 > separate the page cache working set from transient pages due
 > to streaming IO.

Yes, basically FIFO for clean file system pages and FIFO-second-chance
for dirty file pages. Very bad.

 > 
 > I agree that we should put some more negative feedback in
 > place if it turns out we need it.  I have refault code ready
 > that can be plugged into this patch, but I don't want to add
 > the overhead of such code if it turns out we do not actually
 > need it.

In my humble opinion VM already has too many mechanisms that are
supposed to help in corner cases, but there is little to do with that,
except for major rewrite.

Nikita.

