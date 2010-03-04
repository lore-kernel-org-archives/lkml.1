Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0CDQRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:17:34 -0500
Received: from mail-pz0-f126.google.com ([209.85.222.126]:65236 "EHLO
	mail-pz0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0CDQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:17:33 -0500
X-Greylist: delayed 8451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 11:17:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=HvfTU3BBSwzZfaP0m4czTrB/uB+C06YMIr//fIFDk9/6/saX6vDeYP/jHC3qqeTuTe
         LnyP5KmVYQVfV84K3+6rQ7ZsBxJqEvefIJVSS1RCcln51mTppV13LFgmZYwSbpSqhnhy
         ZMrORzU5qqosZs4No3ZgLN56WVeDoKXwdWlho=
MIME-Version: 1.0
Reply-To: teigland@redhat.com
In-Reply-To: <1267706470.14393.422.camel@localhost.localdomain>
References: <1267211864-5474-2-git-send-email-teigland@redhat.com>
	 <1267706470.14393.422.camel@localhost.localdomain>
Date: Thu, 4 Mar 2010 07:56:41 -0600
Message-ID: <c1e1128f1003040556i398edb4w629d15b1be5ff37e@mail.gmail.com>
Subject: Re: [PATCH 1/4] dlm: fix ordering of bast and cast
From: David Teigland <dteigland@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 6:41 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Some questions on this one... shouldn't the filtering of the basts go at
> the start of dlm_add_ast() so that it catches both the basts heading to
> userspace and the ones going via the kernel interface?

Hm, I'm not sure what happened to the userspace part of this which is
only partly there.  Thanks, I'll get that back or done (it's never been a
problem for userspace, but should still be done).  It may make sense to
do some of this earlier for both, I'll have to see.

> Also, when the short-cut of generating casts locally on certain remotly
> mastered demote requests is used, does that somehow suppress the
> generation of casts on the lock master?

yes (it's a reply to the convert which is skipped)

> I notice that the variable lkb->lkb_bastmode_done has been added, but is
> only ever assigned to and never read. Was that supposed to have been
> made accessible via debugfs for example?

Yeah, it was used in an earlier version of this patch with a lot more checking
and debugging.  I'll see if there's some debugging or checking I could add that
uses it or else remove.

Dave
