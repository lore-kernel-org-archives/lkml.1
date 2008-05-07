Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYEGN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYEGN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYEGN6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:58:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41886 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYEGN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:57:59 -0400
Date: Wed, 7 May 2008 07:57:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Message-ID: <20080507135757.GT19219@parisc-linux.org>
References: <200805070003.56387.rjw@sisk.pl> <200805070007.56998.rjw@sisk.pl> <20080507094150.GG13858@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507094150.GG13858@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:41:50AM +0200, Pavel Machek wrote:
> > @@ -182,6 +183,8 @@ __mutex_lock_common(struct mutex *lock, 
> >  		/* didnt get the lock, go to sleep: */
> >  		spin_unlock_mutex(&lock->wait_lock, flags);
> >  		schedule();
> > +		if (state == TASK_KILLABLE)
> > +			try_to_freeze();
> >  		spin_lock_mutex(&lock->wait_lock, flags);
> >  	}
> >  
> 
> I'm not comfortable with this one. Can the task be killable, but still
> hold some _other_ mutex? (and then release it only if it actually gets
> the signal?)

Yes, that's exactly what's supposed to happen.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
