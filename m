Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZFENwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZFENwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZFENwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:52:07 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:41516 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZFENwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eN+zYG5v6PbVupBW2OPb0A1JZo2969P1zuC1G3+Vjg1NtnUuajSc2RJql0lC+KAGyd
         1IUFKyndmf6Q0AfP7sIe3IXuL2JhwAF2VvH99txkMsCX3z32+I4PcoRMjtZLU57JhGP1
         CZ6iVDj18C5n9UK6krooLH3bi4Q6aYXJMUKBw=
MIME-Version: 1.0
In-Reply-To: <20090604201029.GG1065@one.firstfloor.org>
References: <alpine.DEB.2.00.0906021141010.19390@bicker>
	 <87iqjedf2a.fsf@basil.nowhere.org>
	 <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
	 <20090604201029.GG1065@one.firstfloor.org>
Date: Fri, 5 Jun 2009 15:52:07 +0200
Message-ID: <a63d67fe0906050652k51321f18h4588d54954b3eb78@mail.gmail.com>
Subject: Re: smatch 1.53 released
From: Dan Carpenter <error27@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/09, Andi Kleen <andi@firstfloor.org> wrote:
> Thanks for the description.
>
>> So basically you grep for locking functions and you set the state
>> based on that, then you grep for return statements and check that the
>
> When you say "you" you mean smatch is doing that on its own
> or does the user need to do that manually?
>

I meant if you were writing a check for a different type of bug.  The
checks that I mentioned are the ones I have written already.

There is also a line between the core smatch and the checks.  The core
understands code flow and the checks call set_state() and get_state()
and print error messages.  The core is able to handle any C code but
the checks are project specific.

>> Many of the locking false positives come from places where the unlock
>> happens in a seperate function.  It should be relatively straight
>> forward to make a list functions to say that if frob_the_module()
>> returns -12, or -14 that implies it unlocked a certain lock.  I
>> haven't done this yet.
>
> How would one pass  that list of functions to smatch?
>

You can't right now.  That's the bit that I still need to write.  :/
But as an example, one of the checks has a file smatch_data/ with a
list of functions that allocate memory.  Locking functions would be
the same.

> I understand correctly that right now it's not inter procedural in its
> analysis?
>

The null dereference check is, but none of the other checks are.

When the inter procedural analysis is done, it will mostly be a two
pass system where the first step builds a list of functions and what
they imply and the second pass does the check.  Meaning two kernel
compiles.  Or more likely, people will just use the default lists
which will be updated for -rc1 kernels.

Smatch is still in the very early stages.

regards,
dan carpenter

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
