Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYA1JBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYA1JBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYA1JAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:00:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYA1JAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:00:53 -0500
Date: Mon, 28 Jan 2008 01:01:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "minchan kim" <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Martin Bligh" <mbligh@mbligh.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] remove duplicating priority setting in try_to_free_p
Message-Id: <20080128010102.8cbcbdda.akpm@linux-foundation.org>
In-Reply-To: <28c262360801272243h71bf4464s431d1377051c756b@mail.gmail.com>
References: <28c262360801252329q7232edc2l2d0e4ed17c054832@mail.gmail.com>
	<20080127213312.517b8014.akpm@linux-foundation.org>
	<28c262360801272243h71bf4464s431d1377051c756b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 15:43:56 +0900 "minchan kim" <minchan.kim@gmail.com> wrote:

> > I think this is actually a bugfix.  The code you're removing doesn't do the
> >
> >         if (priority < zone->prev_priority)
> >
> > thing.
> >
> 
> shrink_zones() in try_to_free_pages() already called
> note_zone_scanning_priority().
> So, it have done it.

note_zone_scanning_priority() will only permit ->prev_priority to logically
increase, whereas the code which you've removed will also permit
->prev_priority to logically decrease.  So I don't see that they are
equivalent?

