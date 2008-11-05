Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYKEABL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYKEABL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbYKEAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:00:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbYKEAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:00:54 -0500
Date: Tue, 4 Nov 2008 16:00:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Viktor Rosendahl <Viktor.Rosendahl@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/1] Make sure that any oops is flushed to the mtdoops
 console
Message-Id: <20081104160027.d80249fb.akpm@linux-foundation.org>
In-Reply-To: <1225458328.16867.23.camel@viktor.research.nokia.com>
References: <1224688588-2665-1-git-send-email-viktor.rosendahl@nokia.com>
	<1224688588-2665-2-git-send-email-viktor.rosendahl@nokia.com>
	<20081030131734.c74e614d.akpm@linux-foundation.org>
	<1225458328.16867.23.camel@viktor.research.nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 15:05:28 +0200
Viktor Rosendahl <Viktor.Rosendahl@nokia.com> wrote:

> On Thu, 2008-10-30 at 13:17 -0700, ext Andrew Morton wrote: 
> > On Wed, 22 Oct 2008 18:16:28 +0300
> > Viktor Rosendahl <viktor.rosendahl@nokia.com> wrote:
> <clip> 
> > >  void __attribute__((weak)) bust_spinlocks(int yes)
> > > @@ -22,6 +23,7 @@ void __attribute__((weak)) bust_spinlocks(int yes)
> > >  #ifdef CONFIG_VT
> > >  		unblank_screen();
> > >  #endif
> > > +		console_unblank();
> > >  		if (--oops_in_progress == 0)
> > >  			wake_up_klogd();
> > >  	}
> > 
> > That looks logical.  From my reading we can now remove that
> > unblank_screen(), because the console_unblank() will call
> > vt_console_driver.unblank() for us?
> 
> For some reason, we did not think about it here when the N810 kernel was
> fixed. It looks good to me but if you do it, then there will be a slight
> difference in behavior, since console_unblank() will call
> vt_console_driver.unblank() only if the console_sem can be acquired,
> otherwise it just returns without doing anything.
> 
> Maybe console_unblank() should be changed to not care too much about the
> console_sem if an oops is in progress? 
> 

hm, yeah.  Things get messy if we take an oops with console_sem held.

I'll drop the cleanup patch - I don't have time to think about and test
anything useful like that :(


