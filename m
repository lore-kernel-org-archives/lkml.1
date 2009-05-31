Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZEaQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZEaQtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZEaQtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:49:25 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2302 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZEaQtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:49:25 -0400
Date: Sun, 31 May 2009 18:49:25 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090531164925.GA22309@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
	Roland McGrath <roland@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090531140354.GA92675@dspnet.fr.eu.org> <20090531173144.0a552386@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531173144.0a552386@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 05:31:44PM +0100, Alan Cox wrote:
> O> Perhaps removing the "|| r == -EINTR" part would make both of you
> > happy?  He gets the reliability on pipes, you keep the interrupt on
> > signals.
> 
> How does that improve things.

I can very well misunderstand the code, but if you dump to a pipe,
what you can write() in one call is limited to the pipe buffer
capacity, isn't it?  Something like 16 pages iirc.  So you get a short
write and nothing there seems to call write again.

I've also had short writes on normal filesystems (nfs at least,
reiserfs and ext3 too I seem to remember, but it was a 2.6.20-era
kernel) for writes bigger than 2G.  So I'm not sure a dump of a 2G+
process would actually work.


> There is a second problem anyway. Suppose something is causing a
> continual stream of signal events - what guarantees it makes progress ?

Can a signal end up in anything else than EINTR?


> The only source of signals during a dump should be external ones. Far
> better would be to set some kind of defined signal mask during the dump
> (say SIGPIPE, SIGINT, SIGQUIT) ? I agree with Paul's patch in the sense
> we don't want spurious SIGIO events or similar spoiling a dump.

But Paul's patch is not just about signals, it's about EAGAIN and
short writes too.

  OG.

