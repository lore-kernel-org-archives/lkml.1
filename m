Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYCHUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYCHUiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYCHUiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:38:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57505 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYCHUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:38:07 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 8 Mar 2008 12:38:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rik van Riel <riel@redhat.com>
cc: Jeff Roberson <jroberson@chesapeake.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] eventfd signal race in aio_complete()
In-Reply-To: <20080308102321.4527372e@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0803081236440.9905@alien.or.mcafeemobile.com>
References: <20080307161854.E920@desktop> <Pine.LNX.4.64.0803071955490.13626@alien.or.mcafeemobile.com>
 <20080308102321.4527372e@bree.surriel.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Rik van Riel wrote:

> On Fri, 7 Mar 2008 20:29:20 -0800 (PST)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > The second solution/patch simply moves the eventfd_signal() call before 
> > the __aio_put_req() call, but after the event has beed "ringed".
> > We should be clear to go with the shorter/nicer second solution. Those 
> > patches builds, but I'm not even signing them off till I tested them.
> 
> If there are no spinlock ordering issues between &ctx->ctx_lock
> and &ctx->wqh.lock (taken inside eventfd_signal), then the second
> patch is indeed preferable.
> 
> Jeff and I did look at that briefly last night, but were not
> familiar enough with the code to decide whether or not that was
> safe.

There's no interlocking between the two, so let's go with #2.
Jeff, would you mind giving patch #2 a spin in your test suite?



- Davide


