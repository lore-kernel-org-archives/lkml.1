Return-Path: <linux-kernel-owner+w=401wt.eu-S1945916AbXBVAjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945916AbXBVAjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945924AbXBVAjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:39:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945916AbXBVAjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:39:43 -0500
Date: Wed, 21 Feb 2007 16:38:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 4/4] NOMMU: Make it possible for RomFS to use MTD
 devices directly
Message-Id: <20070221163839.b4f5e3b5.akpm@linux-foundation.org>
In-Reply-To: <20070220195106.26186.41931.stgit@warthog.cambridge.redhat.com>
References: <20070220195049.26186.69393.stgit@warthog.cambridge.redhat.com>
	<20070220195106.26186.41931.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 19:51:06 +0000
David Howells <dhowells@redhat.com> wrote:

> +		brelse(bh);

A little fyi: brelse() is rather old-fashioned, and has a usually unneeded
test for non-null bh in it.  In situations where we know that the pointer is 
valid, let's please use put_bh().

Anyway, I'll assume that dwmw2 will be handling this patch series.
