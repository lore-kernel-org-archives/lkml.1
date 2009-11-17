Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKQNPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKQNPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZKQNPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:15:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZKQNPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:15:33 -0500
Date: Tue, 17 Nov 2009 13:15:28 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
Subject: Re: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Message-ID: <20091117131527.GB6644@agk-dp.fab.redhat.com>
Mail-Followup-To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 04:17:07PM +0900, KOSAKI Motohiro wrote:
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.
 
This code is also on the critical path, for example, if you are swapping
onto a dm device.  (There are ways we could reduce its use further as
not every dm ioctl needs to be on the critical path and the buffer size
could be limited for the ioctls that do.)

But what situations have been causing you trouble?  The OOM killer must
generally avoid killing userspace processes that suspend & resume dm
devices, and there are tight restrictions on what those processes
can do safely between suspending and resuming.

Alasdair

