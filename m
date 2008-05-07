Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbYEGSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbYEGSl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYEGSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:41:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189AbYEGSlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:41:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Date: Wed, 7 May 2008 20:41:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matt Helsley <matthltc@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>
References: <200805070003.56387.rjw@sisk.pl> <200805070007.56998.rjw@sisk.pl> <20080507135333.GS19219@parisc-linux.org>
In-Reply-To: <20080507135333.GS19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072041.20210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Matthew Wilcox wrote:
> On Wed, May 07, 2008 at 12:07:55AM +0200, Rafael J. Wysocki wrote:
> > The introduction of TASK_KILLABLE allows the freezer to work in some situation
> > that it could not handle before.
> > 
> > Make the freezer handle killable tasks and add try_to_freeze() in some places
> > where it is safe to freeze a (killable) task.  Introduce the
> > wait_event_killable_freezable() macro to be used wherever the freezing of
> > a waiting killable task is desirable.
> 
> Why do you say that TASK_KILLABLE allows the freezer to work in some
> situations where it couldn't before?  If something's using one of the
> killable functions, it means that it knows how to clean up and unwind
> gracefully if the task receives a fatal signal.  I don't understand what
> connection there is to the freezer.

The reason why we don't freeze uninterruptible tasks is that we don't know
why they are in that state.  If one of tasks is uninterruptible for a
relatively long time, that may indicate a non-recoverable error making it
dangerous to put the system into a sleep state.  If the task is killable,
though, the situation is recoverable.

Thanks,
Rafael
