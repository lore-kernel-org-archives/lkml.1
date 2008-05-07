Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYEGSgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYEGSgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYEGSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:36:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbYEGSgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:36:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH 2/2] Freezer: Try to handle killable tasks
Date: Wed, 7 May 2008 20:35:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Liam Howlett <howlett@gmail.com>
References: <200805070003.56387.rjw@sisk.pl> <20080507094150.GG13858@elf.ucw.cz> <20080507135757.GT19219@parisc-linux.org>
In-Reply-To: <20080507135757.GT19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072035.57450.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Matthew Wilcox wrote:
> On Wed, May 07, 2008 at 11:41:50AM +0200, Pavel Machek wrote:
> > > @@ -182,6 +183,8 @@ __mutex_lock_common(struct mutex *lock, 
> > >  		/* didnt get the lock, go to sleep: */
> > >  		spin_unlock_mutex(&lock->wait_lock, flags);
> > >  		schedule();
> > > +		if (state == TASK_KILLABLE)
> > > +			try_to_freeze();
> > >  		spin_lock_mutex(&lock->wait_lock, flags);
> > >  	}
> > >  
> > 
> > I'm not comfortable with this one. Can the task be killable, but still
> > hold some _other_ mutex? (and then release it only if it actually gets
> > the signal?)
> 
> Yes, that's exactly what's supposed to happen.

The question, though, is whether there is a driver that will try to lock this
mutex in its .suspend() or .resume() callback.  If there is one, TASK_KILLABLE
won't help the freezer indeed.

Thanks,
Rafael
