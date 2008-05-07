Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYEGNyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYEGNyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYEGNxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:53:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41855 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYEGNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:53:51 -0400
Date: Wed, 7 May 2008 07:53:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matt Helsley <matthltc@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Message-ID: <20080507135333.GS19219@parisc-linux.org>
References: <200805070003.56387.rjw@sisk.pl> <200805070007.56998.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805070007.56998.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 12:07:55AM +0200, Rafael J. Wysocki wrote:
> The introduction of TASK_KILLABLE allows the freezer to work in some situation
> that it could not handle before.
> 
> Make the freezer handle killable tasks and add try_to_freeze() in some places
> where it is safe to freeze a (killable) task.  Introduce the
> wait_event_killable_freezable() macro to be used wherever the freezing of
> a waiting killable task is desirable.

Why do you say that TASK_KILLABLE allows the freezer to work in some
situations where it couldn't before?  If something's using one of the
killable functions, it means that it knows how to clean up and unwind
gracefully if the task receives a fatal signal.  I don't understand what
connection there is to the freezer.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
