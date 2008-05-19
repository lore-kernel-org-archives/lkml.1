Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYESW6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYESW6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762029AbYESW60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:58:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35903 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbYESW6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:58:25 -0400
Date: Tue, 20 May 2008 00:59:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Wilcox <matthew@wil.cx>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Message-ID: <20080519225910.GC2315@elf.ucw.cz>
References: <200805070003.56387.rjw@sisk.pl> <200805070007.56998.rjw@sisk.pl> <20080507135333.GS19219@parisc-linux.org> <200805072041.20210.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805072041.20210.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-07 20:41:19, Rafael J. Wysocki wrote:
> On Wednesday, 7 of May 2008, Matthew Wilcox wrote:
> > On Wed, May 07, 2008 at 12:07:55AM +0200, Rafael J. Wysocki wrote:
> > > The introduction of TASK_KILLABLE allows the freezer to work in some situation
> > > that it could not handle before.
> > > 
> > > Make the freezer handle killable tasks and add try_to_freeze() in some places
> > > where it is safe to freeze a (killable) task.  Introduce the
> > > wait_event_killable_freezable() macro to be used wherever the freezing of
> > > a waiting killable task is desirable.
> > 
> > Why do you say that TASK_KILLABLE allows the freezer to work in some
> > situations where it couldn't before?  If something's using one of the
> > killable functions, it means that it knows how to clean up and unwind
> > gracefully if the task receives a fatal signal.  I don't understand what
> > connection there is to the freezer.
> 
> The reason why we don't freeze uninterruptible tasks is that we don't know
> why they are in that state.  If one of tasks is uninterruptible for a
> relatively long time, that may indicate a non-recoverable error making it
> dangerous to put the system into a sleep state.  If the task is killable,
> though, the situation is recoverable.

....but the task may still hold some locks, so we can't "just freeze
it".
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
