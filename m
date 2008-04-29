Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbYD2TKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbYD2TKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763896AbYD2TJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:09:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763850AbYD2TJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:09:52 -0400
Date: Tue, 29 Apr 2008 12:09:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080428140026.32aaf3bf@infradead.org>
Message-ID: <Pine.LNX.4.64.0804291204450.12689@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080429084854.GA14913@elte.hu> <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
 <20080428124849.4959c419@infradead.org> <Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com>
 <20080428140026.32aaf3bf@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Arjan van de Ven wrote:

> > Hmmm... Why do we have CONFIG_FRAMEPOINTER then?
> 
> to make the backtraces more accurate.

Well so we display out of whack backtraces? There are also issues on 
platforms that do not have a stack in the classic sense (rotating register 
file on IA64 and Sparc64 f.e.). Determining a backtrace can be very 
expensive.

> > The current implementation of vmalloc_caller() follows what we have
> > done with kmalloc_track_caller. Its low overhead and always on.
> 
> stacktraces aren't entirely free, the cost is O(nr of modules) unfortunately ;(

The current implementation /proc/vmallocinfo avoids these issues and 
with just one caller address it can print one line per vmalloc request. 
