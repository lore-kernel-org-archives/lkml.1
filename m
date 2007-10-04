Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbXJDV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbXJDV1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXJDV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:27:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997AbXJDV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:27:25 -0400
Date: Thu, 4 Oct 2007 14:26:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org, dgc@sgi.com, kenchen@google.com,
       mrubin@google.com
Subject: Re: [PATCH 4/5] writeback: remove pages_skipped accounting in
 __block_write_full_page()
Message-Id: <20071004142641.9de1ef66.akpm@linux-foundation.org>
In-Reply-To: <391315778.53500@ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn>
	<391315778.53500@ustc.edu.cn>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 16:41:47 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> This patch fixes this bug. Though I'm not sure why __block_write_full_page()
> is called only to do nothing and who actually issued the writeback for us.

kjourald wrote the page's buffers back (ext3 in ordered-data mode).  The VM
didn't know about that, so we have a PageDirty page which has clean
buffers.

We rely upon the VFS writeback code to "discover" that this dirty page has
clean buffers: the VFS will attempt to write the dirty page and will end up
marking the page clean without performing any IO.

