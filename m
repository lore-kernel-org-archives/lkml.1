Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYITWVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYITWVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYITWU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:20:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYITWU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:20:58 -0400
Date: Sat, 20 Sep 2008 15:20:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Timur Tabi" <timur@freescale.com>, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
Message-Id: <20080920152048.75ea4655.akpm@linux-foundation.org>
In-Reply-To: <e9c3a7c20809201440t739ea58enede8d0d6a70f5118@mail.gmail.com>
References: <1221751279-24936-1-git-send-email-timur@freescale.com>
	<20080919163145.de9866ac.akpm@linux-foundation.org>
	<e9c3a7c20809201440t739ea58enede8d0d6a70f5118@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 14:40:40 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:

> When I fix this up is there a
> canonical location to document a callback interface rather than at the
> callback's typedef?

Personally I like to see at at the definition site, so that's within
the struct which contains the function pointer.  eg:

struct address_space_operations {
	int (*writepage)(struct page *page, struct writeback_control *wbc);
	int (*readpage)(struct file *, struct page *);
	void (*sync_page)(struct page *);

	/* Write back some dirty pages from this mapping. */
	int (*writepages)(struct address_space *, struct writeback_control *);

	/* Set a page dirty.  Return true if this dirtied it */
	int (*set_page_dirty)(struct page *page);

(sadly incomplete, but we tried)
