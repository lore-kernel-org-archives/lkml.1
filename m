Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbXEPFck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbXEPFck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbXEPFcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:32:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760330AbXEPFcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:32:32 -0400
Date: Tue, 15 May 2007 22:29:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and
 zero_user
Message-Id: <20070515222912.ae836e00.akpm@linux-foundation.org>
In-Reply-To: <464A8DF5.2010903@yahoo.com.au>
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
	<20070515202442.eeaa49a0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com>
	<464A8DF5.2010903@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 14:52:05 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Christoph Lameter wrote:
> > On Tue, 15 May 2007, Andrew Morton wrote:
> > 
> > 
> >>>   The functions above default to KM_USER0 which is also always used when
> >>>   zero_user_page was called except in one single case. We open code that
> >>>   single case to draw attention to the spot.
> >>>
> >>
> >>Dunno.  fwiw, we decided to _not_ embed KM_USER0 in the callee: we have had
> >>some pretty ghastly bugs in the past due to misuse of kmap slots so the
> >>idea was to shove the decision into the caller's face, make them think
> >>about what they're doing
> > 
> > 
> > On the other hand non highmem platforms are burdened with always repeating
> > the same KM_USER0 in every function call. Isnt it enough to know that 
> > standard functions use KM_USER0 for their operations?
> 
> Couldn't that be filtered out inline?

It is - there is no runtime overhead for non-highmem machines.

The problem nowadays is all the developers who don't need, have, compile
for or test on highmem machines.

