Return-Path: <linux-kernel-owner+w=401wt.eu-S933370AbYD2TCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbYD2TCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762329AbYD2TA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:00:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58059 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbYD2TA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:00:57 -0400
Date: Mon, 28 Apr 2008 14:00:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080428140026.32aaf3bf@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com>
	<20080318222827.519656153@sgi.com>
	<20080429084854.GA14913@elte.hu>
	<Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
	<20080428124849.4959c419@infradead.org>
	<Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:49:54 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 28 Apr 2008, Arjan van de Ven wrote:
> 
> > > Sorry lost track of this issue. Adding stracktrace support is not
> > > a trivial thing and will change the basic handling of vmallocinfo.
> > > 
> > > Not sure if stacktrace support can be enabled without a penalty on
> > > various platforms. Doesnt this require stackframes to be
> > > formatted in a certain way?
> > 
> > it doesn't.
> 
> Hmmm... Why do we have CONFIG_FRAMEPOINTER then?

to make the backtraces more accurate.


> The current implementation of vmalloc_caller() follows what we have
> done with kmalloc_track_caller. Its low overhead and always on.

stacktraces aren't entirely free, the cost is O(nr of modules) unfortunately ;(
