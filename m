Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYEEWZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYEEWZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbYEEWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:25:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594AbYEEWZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:25:41 -0400
Date: Mon, 5 May 2008 15:24:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
Message-Id: <20080505152451.6dceec74.akpm@linux-foundation.org>
In-Reply-To: <20080503213814.3140.66080.sendpatchset@localhost.localdomain>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	<20080503213814.3140.66080.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 03:08:14 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +	if (res_counter_charge(&rcg->as_res, (mm->total_vm << PAGE_SHIFT)))

I worry a bit about all the conversion between page-counts and byte-counts
in this code.

For example, what happens if a process sits there increasing its rss with
sbrk(4095) or sbrk(4097) or all sorts of other scenarios?  Do we get in a
situation in which the accounting is systematically wrong?

Worse, do we risk getting into that situation in the future, as unrelated
changes are made to the surrounding code?

IOW, have we chosen the best, most maintainable representation for these
things?

