Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbXJPJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbXJPJJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXJPJJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:09:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322AbXJPJJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:09:33 -0400
Date: Tue, 16 Oct 2007 02:08:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: Possible circular locking: ->mmap_sem vs jbd_handle
Message-Id: <20071016020826.6a0263cd.akpm@linux-foundation.org>
In-Reply-To: <1192525512.27435.90.camel@twins>
References: <20071016085429.GA6352@localhost.sw.ru>
	<20071016020159.5cff8976.akpm@linux-foundation.org>
	<1192525512.27435.90.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 11:05:12 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2007-10-16 at 02:01 -0700, Andrew Morton wrote:
> > On Tue, 16 Oct 2007 12:54:29 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > 
> > > Got this during LTP's diotest1. Reproducable.
> > > 
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.23-65a6ec0d72a07f16719e9b7a96e1c4bae044b591 #2
> > > -------------------------------------------------------
> > > diotest1/13563 is trying to acquire lock:
> > >  (&mm->mmap_sem){----}, at: [<c107a7b7>] dio_get_page+0x4b/0x16b
> > > 
> > > but task is already holding lock:
> > >  (jbd_handle){--..}, at: [<c1099b05>] journal_start+0xf3/0x120
> > > 
> > > which lock already depends on the new lock.
> > 
> > Someone taught lockdep about journal_start?  That's gonna hurt.
> 
> It was you who suggested doing so,...

yeah, but I didn't think anyone would go and do it!

> Are these valid reports, or is the annotation wrong?

It's valid.  There will be others..

