Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXHBXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXHBXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXHBXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:18:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551AbXHBXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:18:42 -0400
Date: Thu, 2 Aug 2007 16:17:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       "Ingo Molnar" <mingo@elte.hu>, "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion
 (mpt_attach())
Message-Id: <20070802161730.1d5bb55b.akpm@linux-foundation.org>
In-Reply-To: <9a8748490708021610k31a86c17y58fb631a36dfdb6a@mail.gmail.com>
References: <200708020155.33690.jesper.juhl@gmail.com>
	<20070801172653.1fd44e99.akpm@linux-foundation.org>
	<9a8748490708020120w4bbfe6d1n6f6986aec507316@mail.gmail.com>
	<200708030053.45297.jesper.juhl@gmail.com>
	<20070802160406.5c5b5ff6.akpm@linux-foundation.org>
	<9a8748490708021610k31a86c17y58fb631a36dfdb6a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007 01:10:02 +0200
"Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> > > So, where do we go from here?
> >
> > Where I said ;) Add a new __GFP_ flag which suppresses the warning, add
> > that flag to known-to-be-OK callsites, such as mempool_alloc().
> >
> Ok, I'll try to play around with this some more, try to filter out
> false positives and see what I'm left with (if anything - I'm pretty
> limited hardware-wise, so I can only test a small subset of drivers,
> archs etc) - I'll keep you informed, but expect a few days to pass
> before I have any news...

Make it a once-off thing for now, so the warning will disable itself after
it has triggered once.  That will prevent the debug feature from making
anyone's kernel unusable.
