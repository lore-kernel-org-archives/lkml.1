Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZFQQJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZFQQJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZFQQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:08:55 -0400
Received: from fifo99.com ([67.223.236.141]:57460 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZFQQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:08:54 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny
	&&	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       arve@android.com, linux-kernel@vger.kernel.org
In-Reply-To: <4A390B9A.40806@goop.org>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 09:08:56 -0700
Message-Id: <1245254936.5982.261.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 08:28 -0700, Jeremy Fitzhardinge wrote:
> On 06/17/09 07:37, Daniel Walker wrote:
> > I agree it's reasonable in some cases.. The reason I changed this is
> > because at first glance I didn't know what those lines were suppose to
> > do. The equals signs all bleed together combined with the length of the
> > statement makes it not match other similar usage. The if statement just
> > makes the whole thing explicit.
> >    
> 
> I definitely see your point, but the if() statement variant has the 
> downside of only conditionally assigning the variable, and requiring it 
> to be initialized separately.  I have a general code-cleanup rule to 
> convert:
> 
> 	foo = false;
> 	if (something_is_true())
> 		foo = true;
> 
> to
> 
> 	foo = something_is_true();

Above seems more like a speed up, rather than a clean up. I would think
it's likely fine for a lot of cases tho.

> 
> Maybe a bit of reformatting and some tactical use of parens would help?
> 
> 	wait_for_proc_work = (!thread->transaction_stack&&  list_empty(&thread->todo));
> 
> (I'm not normally a fan of NULL-as-false, but it reads OK here.)

I'm ok with this change for the first of the two, but the second one is
too long.. However, I reviewed the code a little more and I think the
wait_for_proc_work variable could likely get eliminated in the second
case. There is something racy going on wrt. to the variable in the
second case. So it probably better for me to just drop the second change
in hopes of a more detailed cleanup.

> > Not to mention this code is a mess, very dense, and has little or no
> > comments. Anything that can be done to make the code more clear, seem
> > like a cleanup to me.
> >    
> 
> No argument from me.  Not to mention that I have no idea from reading 
> the code what the whole subsystem is for; "Android IPC Subsystem" 
> doesn't tell me much, other than a gnawing feeling about having yet 
> another IPC subsystem to deal with.

I was hoping Brian could explain this. I also added Arve (the author) to
the CC list. Maybe they can explain the purpose of the subsystem.

> > As for using "bool" , AFAIK that's only part of C++ ..
> >    
> 
> No, it is also C99, and becoming widely used in the kernel.

Was this a recent change to C99, cause my compiler still doesn't know
about it .. I also see a couple places in the kernel where bool is
getting typedef'ed or somehow declared..

Daniel

