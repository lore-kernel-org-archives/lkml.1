Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYCHPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYCHPXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYCHPXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:23:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYCHPXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:23:41 -0500
Date: Sat, 8 Mar 2008 10:23:21 -0500
From: Rik van Riel <riel@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Jeff Roberson <jroberson@chesapeake.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] eventfd signal race in aio_complete()
Message-ID: <20080308102321.4527372e@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0803071955490.13626@alien.or.mcafeemobile.com>
References: <20080307161854.E920@desktop>
	<Pine.LNX.4.64.0803071955490.13626@alien.or.mcafeemobile.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 20:29:20 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> The second solution/patch simply moves the eventfd_signal() call before 
> the __aio_put_req() call, but after the event has beed "ringed".
> We should be clear to go with the shorter/nicer second solution. Those 
> patches builds, but I'm not even signing them off till I tested them.

If there are no spinlock ordering issues between &ctx->ctx_lock
and &ctx->wqh.lock (taken inside eventfd_signal), then the second
patch is indeed preferable.

Jeff and I did look at that briefly last night, but were not
familiar enough with the code to decide whether or not that was
safe.

-- 
All rights reversed.
