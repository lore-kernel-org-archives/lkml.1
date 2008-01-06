Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbYAFOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbYAFOvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760052AbYAFOrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:47:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:31726 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033AbYAFOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Dcn5gDkrHSnuX1ggI/oTERQmivOzZHhqC6Q2SBvvT0K/mgFaOauJFS/bAhXBhrGgRHAGHjDOix+dJKoVc94cHE7YsQVrBj3Qw6TxSXFMyn5S3s+QF2JBoOLAujnMbxuqbuPBRa6oMoiEU6RsdrGpoUU5O5uNxGg0NB4Inybrl2I=
Date: Sun, 6 Jan 2008 15:52:27 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       netdev@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080106145227.GB3117@ami.dom.local>
References: <64bb37e0801040223q17a76565k3c7667a197403ce5@mail.gmail.com> <20080104133031.GA3329@ff.dom.local> <64bb37e0801040721p57ff3d54wc3de00546d1d2ff1@mail.gmail.com> <20080105000700.GA3224@ami.dom.local> <64bb37e0801050001x65b104bdl5a68c731b3656d17@mail.gmail.com> <20080105101327.GA3103@ami.dom.local> <64bb37e0801050652t7568e438uf93208601df84ef6@mail.gmail.com> <20080106082740.GA3117@ami.dom.local> <64bb37e0801060230x6b392542la9556d72a184f306@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0801060230x6b392542la9556d72a184f306@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 11:30:48AM +0100, Torsten Kaiser wrote:
...
> I think this bug is highly timing dependent. Its not always the same
> package that dies and as this is a SMP system I would guess two CPUs
> using the same data will trigger this.
> And using the poison-option will definitily slow the system down and
> mess up the timings.

Of course it looks like using the same data, but it seems there is no
reason to think it needs the same time: e.g. some timer or workqueue
could retrigger after it's supposed to be killed. Any additional
debugging/poisonning might help to see it earlier, so this should be
safer for your system, but, most probably this would show data from
the damaged side, so not necessarily very helpful.

> What also speaks against the 'safer' offsets is, that after adding my
> notfreed-byte to skbuff the bug still triggered in the same way.

We are not even sure skbuffs were directly affected by this or they
were incorrectly freed because of other structures beeing damaged?

IMHO, e.g. starting your system with limited memory should cause
faster memory reclaiming, and thus more often triggering of these bugs,
but of course I can be wrong.

Jarek P.
