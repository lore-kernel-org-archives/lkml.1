Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679Ab0ABNwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0ABNwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392Ab0ABNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:52:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34059 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227Ab0ABNwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:52:16 -0500
Date: Sat, 2 Jan 2010 13:55:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Message-ID: <20100102135525.08fe85eb@lxorguk.ukuu.org.uk>
In-Reply-To: <hhmoos$vnu$1@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	<20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
	<hhioif$j9t$3@taverner.cs.berkeley.edu>
	<20100101144629.54fe6cb6@lxorguk.ukuu.org.uk>
	<hhmoos$vnu$1@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Can be - but its historically been an endless source of bugs and flaws
> >because the code being run after you take the rights away is being run in
> >an environment it didn't expect and wasn't tested in.
> 
> Are you just *shrugging* at the goals underlying these efforts?
> The goals of enabling privilege separation and sandboxing seem like
> highly laudable goals to me.  I don't understand why anyone would
> be opposed to efforts to achieve those goals.

I am just pointing out the dangers of continuing to blindly pursue that
model without thinking about the bigger picture. Something Unix security
has taught people is that the model of removing rights isn't the right
one if applied simplistically.

A good example is how fd 0/1/2 is handled these days. The kernel or C
library in the Linux case puts a setuid process into a sensible context
rather than just saying "oh you removed the access to this fd, thats
cool"

If you are going to add more and more "take away the right to" type
features it's more and more important that an application can be run in
the context it expects. That is running a setuid application should
throw off various random restrictions automatically so that it gets the
expected context, without cpu limit surprises, memory restrictions etc.

That in turn reads on the rest of your policy because you have to think
very hard what kind of escape hatch you might be creating.
 
> Privilege-separation is a powerful software architecture technique.
> It's been used in openssh, qmail, vsftpd, and other highly regarded
> security-critical applications.  (When a software designer uses privilege
> separation, he *intends* for his code to be run in a low-privilege
> environment.  That's not a source of bugs.)

Internally yes - its when stuff gets run from the outside it gets harder.

> How many examples have there been?  I can think of one of any significance
> (sendmail).  In any case, I would classify these flaws as inherently
> relatively low-severity, because they can only be exploited by local
> users.

The number of file handle based attacks has been quite large if not very
public. There have been lots of quota based attacks, some CPU limit based
attacks, hangup bases attacks and more. Classics like SGI passwd for
example.

If you are really bored take a look how many setuid apps directly or
indirectly call a memory allocator (usually indirectly via C lib
functions) and don't check the result. Now play with the memory limits

> Perhaps I'm reading you wrong, but I seem to sense an attitude where you
> consider privilege separation and sandboxing to be relatively unimportant,
> and where you consider the risk of local attacks on setuid programs to
> be unavoidable and of paramount importance.  I'm surprised to get this
> impression, because that seems narrow and counter-productive to me.

I care about both. Working on building a mass market OS doesn't give you
the privilege of saying "Oh but persohnally I don't give a **** about
XYZ"

Alan
