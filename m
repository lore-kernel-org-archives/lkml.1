Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZFSPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZFSPIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFSPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:08:24 -0400
Received: from fifo99.com ([67.223.236.141]:54360 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZFSPIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:08:23 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090619145938.GB1389@ucw.cz>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org>  <20090619145938.GB1389@ucw.cz>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 08:08:26 -0700
Message-Id: <1245424106.32124.4.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 16:59 +0200, Pavel Machek wrote:
> >>   	int ret = 0;
> >> -	int wait_for_proc_work;
> >> +	int wait_for_proc_work = 0;
> >>
> >>   	if (*consumed == 0) {
> >>   		if (put_user(BR_NOOP, (uint32_t __user *)ptr))
> >> @@ -2155,8 +2155,8 @@ static int binder_thread_read(struct binder_proc *proc,
> >>   	}
> >>
> >>   retry:
> >> -	wait_for_proc_work = thread->transaction_stack == NULL&&
> >> -				list_empty(&thread->todo);
> >> +	if (list_empty(&thread->todo)&&  thread->transaction_stack == NULL)
> >> +		wait_for_proc_work = 1;
> >>    
> >
> > I think the original looks cleaner (in both cases).  Assigning a  
> > variable with the result of a boolean expression is perfectly  
> > reasonable.  Perhaps change the type of the variable to "bool" to make  
> > it a bit clearer what's going on.
> >
> > (It would be a different matter if any of the expression had side-effects.)
> 
> Plus you have broken whitespace in there, changed performance
> characteristics (list_empty now done first) and with gotos used around
> that code I'm not at all sure transformation is equivalent.

The broken whitespace was only in replies to the original patch, not
sure how it made it in there. We already resolved most of what your
commenting. Unless you care to comment on a later email.

Daniel

