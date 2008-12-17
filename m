Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759088AbYLQLsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbYLQLsX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLQLsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:48:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYLQLsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:48:11 -0500
Date: Wed, 17 Dec 2008 11:48:07 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: crquan@gmail.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm-target.c: simplify target_type to avoid kmalloc
Message-ID: <20081217114807.GD25976@agk.fab.redhat.com>
Mail-Followup-To: crquan@gmail.com, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <1228822355-12674-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228822355-12674-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 07:32:35PM +0800, crquan@gmail.com wrote:
> Move the list_head from tt_internal into struct target_type embedded,
> The struct tt_internal is totally unneeded, and the kmalloc is avoided,
> block of memory copy is also avoided
 
> The only defect is that dm_register_target users cannot use const
> target_type anymore.
 
Target registrations should be rare one-off events.  The existing trade-off is
in favour of a cleaner interface (that does not expose private fields).  The
struct target_type passed to dm_register_target is always static read-only data
and perhaps that could be enforced and a pointer stored in tt_internal instead
of making a copy.

> the function of tt_internal's use field is replaced by the module's
> reference count.
 
That is an independent change I think: please submit it as a separate patch.
When this was first written, the module reference count was managed differently
by this code so I can well believe 'use' is now superfluous.

Alasdair
-- 
agk@redhat.com
