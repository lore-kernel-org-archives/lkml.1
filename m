Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbZAIAdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbZAIAdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZAIAdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:33:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53253 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754296AbZAIAda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:33:30 -0500
Date: Fri, 9 Jan 2009 00:32:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
 while holding sb_lock
Message-ID: <20090109003239.06f73bd1@lxorguk.ukuu.org.uk>
In-Reply-To: <49668388.708@linux.intel.com>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
	<1231425472.21528.13.camel@norville.austin.ibm.com>
	<20090108072111.1ebadebd@infradead.org>
	<1231429591.27353.14.camel@norville.austin.ibm.com>
	<20090108225050.GL9448@disturbed>
	<49668388.708@linux.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 14:51:52 -0800
Arjan van de Ven <arjan@linux.intel.com> wrote:

> Dave Chinner wrote:
> > On Thu, Jan 08, 2009 at 09:46:31AM -0600, Dave Kleikamp wrote:
> >> sync_filesystems() shouldn't be calling async_synchronize_full_special
> >> while holding a spinlock.  The second while loop in that function is the
> >> right place for this anyway.
> > 
> > Out of curiousity, what on earth does
> > async_synchronize_full_special() do and why does it need to be in
> > sync_filesystems()?
> > 
> now that we have asynchronous operations, this function makes sure that all the functions
> that we started async before this point complete, so that what when you sync, you sync all in progress work.

So why is it special - wouldn't async_synchronize_all() be a bit (or
complete_all) be a bit more clear ?

Alan
