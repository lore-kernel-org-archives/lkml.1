Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbZFQOhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbZFQOhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZFQOhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:37:48 -0400
Received: from fifo99.com ([67.223.236.141]:58672 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbZFQOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:37:47 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A380494.6030506@goop.org>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 07:37:49 -0700
Message-Id: <1245249469.5982.251.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 13:46 -0700, Jeremy Fitzhardinge wrote:
> >
> >   retry:
> > -	wait_for_proc_work = thread->transaction_stack == NULL&&
> > -				list_empty(&thread->todo);
> > +	if (list_empty(&thread->todo)&&  thread->transaction_stack == NULL)
> > +		wait_for_proc_work = 1;
> >    
> 
> I think the original looks cleaner (in both cases).  Assigning a 
> variable with the result of a boolean expression is perfectly 
> reasonable.  Perhaps change the type of the variable to "bool" to make 
> it a bit clearer what's going on.

I agree it's reasonable in some cases.. The reason I changed this is
because at first glance I didn't know what those lines were suppose to
do. The equals signs all bleed together combined with the length of the
statement makes it not match other similar usage. The if statement just
makes the whole thing explicit.

Not to mention this code is a mess, very dense, and has little or no
comments. Anything that can be done to make the code more clear, seem
like a cleanup to me.

As for using "bool" , AFAIK that's only part of C++ ..

Daniel

