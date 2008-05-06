Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbYEFAoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbYEFAoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbYEFAn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:43:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997AbYEFAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:43:57 -0400
Date: Mon, 5 May 2008 20:43:18 -0400
From: Rik van Riel <riel@redhat.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Message-ID: <20080505204318.3f95c83c@bree.surriel.com>
In-Reply-To: <2f11576a0805051523h730fce0foa51f1fdbf9c46cbe@mail.gmail.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080505175142.7de3f27b@cuia.bos.redhat.com>
	<2f11576a0805051523h730fce0foa51f1fdbf9c46cbe@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 07:23:18 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> hmmm, AFAIK,
> on current kernel, sometimes __GFP_IO task wait for non __GFP_IO task
> by lock_page().
> Is this wrong?

This is fine.

The problem is adding a code path that causes non __GFP_IO tasks to
wait on __GFP_IO tasks.  Then you can have a deadlock.
 
> therefore my patch care only recursive reclaim situation.
> I don't object to your opinion. but I hope understand exactly your opinion.

I believe not all non __GFP_IO or non __GFP_FS calls are recursive
reclaim, but there are some other code paths too.  For example from
fs/buffer.c

-- 
All rights reversed.
