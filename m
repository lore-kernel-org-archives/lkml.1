Return-Path: <linux-kernel-owner+w=401wt.eu-S1763657AbZEHVCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763657AbZEHVCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZEHVBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:01:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194AbZEHVBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:01:53 -0400
Date: Fri, 8 May 2009 13:56:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       cl@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
Message-Id: <20090508135632.9c041339.akpm@linux-foundation.org>
In-Reply-To: <1241795428.28600.60.camel@penberg-laptop>
References: <1241795428.28600.60.camel@penberg-laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 18:10:28 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)

urgh, you have to be kidding me.  This significantly worsens complexity
and risk in core MM and it's just yuk.

I think we can justify pulling such dopey party tricks to save
pageframe space, or bits in page.flags and such.  But just to save a
scrap of memory which would have been released during boot anwyay? 
Don't think so.

I'd suggest panic_if_null().  Or just leave everything alone - it's
hardly a pressing problem.

