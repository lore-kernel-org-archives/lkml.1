Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZFQP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZFQP2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZFQP2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:28:41 -0400
Received: from claw.goop.org ([74.207.240.146]:57751 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZFQP2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:28:40 -0400
Message-ID: <4A390B9A.40806@goop.org>
Date: Wed, 17 Jun 2009 08:28:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&	usage
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
In-Reply-To: <1245249469.5982.251.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 07:37, Daniel Walker wrote:
> I agree it's reasonable in some cases.. The reason I changed this is
> because at first glance I didn't know what those lines were suppose to
> do. The equals signs all bleed together combined with the length of the
> statement makes it not match other similar usage. The if statement just
> makes the whole thing explicit.
>    

I definitely see your point, but the if() statement variant has the 
downside of only conditionally assigning the variable, and requiring it 
to be initialized separately.  I have a general code-cleanup rule to 
convert:

	foo = false;
	if (something_is_true())
		foo = true;

to

	foo = something_is_true();


Maybe a bit of reformatting and some tactical use of parens would help?

	wait_for_proc_work = (!thread->transaction_stack&&  list_empty(&thread->todo));

(I'm not normally a fan of NULL-as-false, but it reads OK here.)

> Not to mention this code is a mess, very dense, and has little or no
> comments. Anything that can be done to make the code more clear, seem
> like a cleanup to me.
>    

No argument from me.  Not to mention that I have no idea from reading 
the code what the whole subsystem is for; "Android IPC Subsystem" 
doesn't tell me much, other than a gnawing feeling about having yet 
another IPC subsystem to deal with.

> As for using "bool" , AFAIK that's only part of C++ ..
>    

No, it is also C99, and becoming widely used in the kernel.

     J
