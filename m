Return-Path: <linux-kernel-owner+w=401wt.eu-S1423003AbXCGWBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423003AbXCGWBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423009AbXCGWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:01:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:1273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423003AbXCGWBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NU+MHACCIzXEazih4cuIoo4O2183SSn8Fzh7zL8qpfLO4oh7GTu9x0UcMAI0Xm2zEY7/zKe20gqc31cIRWcGOsfncnU0AQTNYpZNWkbotDbP1HS+sy3fDORkFz3LK2Uhh4bKY+EnlaHQsbs/h3PEVje64OD08XMGnliCkIANkYs=
Message-ID: <a36005b50703071401m2b166832rb06f4cf73224f45e@mail.gmail.com>
Date: Wed, 7 Mar 2007 14:01:33 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
	 <20070307233833.f1482f86.sfr@canb.auug.org.au>
	 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
	 <45EF20F7.1050307@goop.org>
	 <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
	 <45EF2DFF.4060209@goop.org>
	 <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 1) You want standard delivery only:
> >
> >    - Just dont use signalfd
> >
> > 2) you want signalfd only:
> >
> >    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
> >
> > If you want both, you can have it. Race free.
>
> .. but maybe with more code and lots of confusion. I'm still unclear on
> any upsides here.
>
> Choice is good, but only if it's *useful* choice.

Not only that.  If you don't force that the signal is blocked when
using signalfd() you are bound to run into problems.  For the same
reason is it required to have signals blocked when you use sigwait()
etc.  Don't try to innovate here, I guarantee you it's going to break
something somewhere.
