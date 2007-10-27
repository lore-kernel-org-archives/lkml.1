Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbXJ0Jee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbXJ0Jee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXJ0Je1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:34:27 -0400
Received: from doom.schmorp.de ([87.139.53.102]:44740 "EHLO doom.schmorp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXJ0Je0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:34:26 -0400
Date: Sat, 27 Oct 2007 11:34:24 +0200
From: Marc Lehmann <schmorp@schmorp.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Marc Lehmann <linux-kernel@tst.eu>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
Message-ID: <20071027093424.GA31329@schmorp.de>
Mail-Followup-To: Eric Dumazet <dada1@cosmosbay.com>,
	Marc Lehmann <linux-kernel@tst.eu>, linux-kernel@vger.kernel.org,
	Davide Libenzi <davidel@xmailserver.org>
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de> <47230351.8040100@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47230351.8040100@cosmosbay.com>
X-PGP: "1024D/DA743396 1999-01-26 Marc Alexander Lehmann <schmorp@schmorp.de>
       Key fingerprint = 475A FE9B D1D4 039E 01AC  C217 A1E8 0270 DA74 3396"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:22:25AM +0200, Eric Dumazet <dada1@cosmosbay.com> wrote:
> >Well, it behaves like documented, which is the problem. You admit you
> >don't understand the problem or the documentation, so again, no need to
> >insult me.
> 
> Hum... I will update my english vocabulary and mark "missed" as an insult.

Well, ignoring my arguments by claiming I lack understanding is an insult,
as you didn't take my arguments at face value but declassified them by
attacking my person.

> I have no problem with epoll nor its documentation.

Thats fine for you. But I have, at least, with epoll, as the documented
and observed behaviour makes epoll unusable as a general event loop
replacement.

> It doesnt on every kernels I had played with. And I played with *lot* of 
> kernels you know.

No, I don't know that. And so far you only said you used fork+exec, not
close in between, so maybe the playing you did was not related to this
problem?

I also played with a lot of kernels, but for epoll specifically, I played
with 2.6.21-2-amd64 and 2.6.22-1-amd64, both from debian unstable with no
customisations.

> If such a bug exists on your kernel, please fill a complete bug report, 
> giving details.

As this behaviour is clearly documented in the epoll manpage, why do you
think it is a bug? I think its fairly bad, but at least tis documented as
the behaviour it should be:

    Q6     Will the close of an fd cause it to be removed from all epoll sets automatically?
    A6     Yes.

As such filing, a bug report for behaviour which isn't in fact a bug would
be counterproductive. My goal in my mail was to find out if there are
work arounds for this peculiar behaviour (Or inspire discussion on this
behaviour).

Of course, one can create big programs using epoll to their advantage. I
never claimed otherwise. But as a general event loop replacement (i.e.
outside of controleld environments), epoll does not currently qualify,
as I would have to control an awful lot of code (think of an perl module
interfacing to epoll: you would not have to control all third-party
modules that might interfere with fork+close+exec. This is very common in
scripting languages).

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      pcg@goof.com
      -=====/_/_//_/\_,_/ /_/\_\
