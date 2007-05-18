Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbXERHVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbXERHVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXERHVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:21:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbXERHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:21:37 -0400
Date: Fri, 18 May 2007 00:19:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070518001905.54cafeeb.akpm@linux-foundation.org>
In-Reply-To: <20070518040854.GA15654@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 06:08:54 +0200 Nick Piggin <npiggin@suse.de> wrote:

> Many batch operations on struct page are completely random,

But they shouldn't be: we should aim to place physically contiguous pages
into logically contiguous pagecache slots, for all the reasons we
discussed.

If/when that happens, there will be a *lot* of locality of reference
against the pageframes in a lot of important codepaths.

