Return-Path: <linux-kernel-owner+w=401wt.eu-S937615AbXFHAKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937615AbXFHAKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932842AbXFHAKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:10:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765730AbXFHAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:10:32 -0400
Date: Thu, 7 Jun 2007 17:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Will Schmidt <will_schmidt@vnet.ibm.com>, linux-kernel@vger.kernel.org,
       liuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all
 threads in process group
Message-Id: <20070607171018.d51fc5da.akpm@linux-foundation.org>
In-Reply-To: <20070607231621.GB32549@kryten>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
	<20070607153459.2a1b3230.akpm@linux-foundation.org>
	<20070607231621.GB32549@kryten>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 18:16:21 -0500
Anton Blanchard <anton@samba.org> wrote:

>  
> Hi,
> 
> > zap_other_threads() requires tasklist_lock.
> > 
> > If we're going to do this then we should probably create some new function
> > (with a better name) which takes tasklsit_lock and then calls
> > zap_other_threads().
> > 
> > Does this patch fix any observed-in-the-real-world problem?  If so, please
> > describe it.
> 
> Yeah we have had complaints where threaded apps have only one thread
> shot down instead of the entire process. This leaves the application in
> a bad state, whereas if it had been killed cleanly the application could
> have restarted.
> 
> My understanding is that fatal signals should kill all threads in the
> group.
> 

OK, well could we please get all that info appropriatelt captured in #2's
changelog?

Other architectures will probably need to implement this.
