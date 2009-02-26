Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZBZFfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZBZFfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZBZFfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:35:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbZBZFff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:35:35 -0500
Date: Wed, 25 Feb 2009 21:34:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-Id: <20090225213428.1f1abb1f.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0902252042510.12697@gandalf.stny.rr.com>
References: <20090225203007.582030664@goodmis.org>
	<20090225203427.382137706@goodmis.org>
	<20090225155648.acb93cff.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902252042510.12697@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 20:46:11 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> > 
> > There are arguments either way.  Lately we've tended to take the
> > position that a whole interface either is or is not wholly exported. 
> > The uaccess functions are exported, so this one should be as well.
> > 
> > We can of course do that later on, when there's a user - I have no
> > particular preference personally.
> > 
> > <looks at probe_kernel_read and probe_kernel_write>
> > 
> > These are really part of the uaccess interface too.  I don't see a need
> > for both lib/uaccess.c and mm/maccess.c?
> 
> Ah, I didn't notice that file. I could move this to that file, or move the 
> maccess to this file. I just thought lib would be a better location.
> What would you suggest?

Don't care much.  There is no rationale for the "maccess" name though -
there's no such term in Linux.  lib/uaccess.c seems a fine place for
such things.

> > 
> > probe_kernel_read() and probe_kernel_write() are EXPORT_SYMBOL_GPL,
> > whereas the rest of the uaccess interface is EXPORT_SYMBOL.  Ho hum.
> 
> Looks like another clean up. I guess probe_kernel is because it is more 
> kernel internals and should not be used by binary modules? Although 
> nothing prevents a kernel module from using the uaccess code for the 
> kernel. Or even make a fault section themselves.

hm, yes.  And I can't find any module which calls probe_kernel_*(). 
Perhaps that export was added for consistency, even though it's
inconsistently licensed.

