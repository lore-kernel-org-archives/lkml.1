Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZBEI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZBEI1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbZBEI1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:27:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:35636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZBEI1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tIsthf1Wy4xQAcnB21tm4xm8R9iUMQ+4XQ6pJe1xytcn7h71pbTk39pxXXtX3TrosL
         XUquoK1hetbef7Xrsq58mv0pTAqzHBxRiEl47ChtkektzvwvsQQbR3NazAD59I25b3f9
         eKQGN+zDuJ4gwxo7SyjIZmGabr9Qn8pxP1uaw=
MIME-Version: 1.0
In-Reply-To: <adaskmtjsnn.fsf@cisco.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <20090204221451.GA27254@uranus.ravnborg.org>
	 <adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	 <adaskmtjsnn.fsf@cisco.com>
Date: Thu, 5 Feb 2009 09:26:58 +0100
Message-ID: <56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 7:37 AM, Roland Dreier <rdreier@cisco.com> wrote:
>  > Just how many of these warnings are showing up? In the cases you
>  > posted it's presumably no problem, but if the string could either a)
>  > be potentially set by a malicious user or b) accidentally contain
>  > printk format characters then this code has a risk that things could
>  > blow up..
>
> I get ~150 of them on an x86 allyesconfig build here (see below).  Many
> but not all are trivial; some at least appear to be passing in strings
> that come from random hardware/firmware or DNS names etc (ie there's at
> least a chance of a '%'); and I didn't exhaustively audit to make sure
> none of them could print something from an unprivileged user.
>

There are probably some real bugs in there. On the other hand there is
some overhead to fixing the warnings. Kernel text size increase,
possibly some CPU overhead from parsing the format string. Hopefully
none of these calls are in really hot code paths ;-)
As I noted applying a patch that does the reverse and enables the
check instead is perfectly acceptable to me. Long term somebody
probably needs to go through all of them and fix (most of) them
anyway.

What remains an open question to me though is what to do with cases
where the warning not only can be ignored but literally should be. eg.
when there is zero chance of something unexpected getting passed in
and 'fixing' it would just bloat the kernel.
Can sparse be used to check this kind of thing for correctness?

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
