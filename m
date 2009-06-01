Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZFAS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZFAS2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZFAS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:28:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZFAS23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:28:29 -0400
Date: Mon, 1 Jun 2009 20:23:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601182305.GA16372@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk> <20090601171119.GA13970@redhat.com> <20090601184608.6379440c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601184608.6379440c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Alan Cox wrote:
>
> > > If you are on the command line then SIGINT/SIGQUIT would be the obvious
> > > ones for this ?
> >
> > Not sure I understand. Do you mean we should treat the tty signals
> > specially ?
>
> Yes
>
> > Personally, I don't think we should. If we decide that only SIGKILL
> > interrupts the coredumping, then I think ^C should not interrupt.
>
> Wait until you have a remote session over ssh that core dumps a 2GB core.
> Then you'll understand why being able to ^C or ^\ it is useful.

Sure. But you have the same problem with

	$ perl -e '$SIG{INT} = $SIG{QUIT} = IGNORE; sleep'
	^C^C^C^\^\^\

over ssh.

And what if the coredumping task already has the pending SIGINT/SIGQUIT
or blocks/ignores them?

But don't get me wrong, I do agree this is useful, and this can be
implemented. But in this case, imho kill(SIGINT) should work as well,
not just ^C.


In short, I agree in advance with any authoritative decision. But
if we add more power to ^C (compared to kill), this should be a
separate patch imho.

Oleg.

