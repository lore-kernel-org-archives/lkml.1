Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZEaOEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZEaOEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZEaODy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:03:54 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2688 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZEaODx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:03:53 -0400
Date: Sun, 31 May 2009 16:03:54 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090531140354.GA92675@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
	Roland McGrath <roland@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 11:18:51AM +0100, Alan Cox wrote:
> On Sun, 31 May 2009 01:33:39 -0400
> Paul Smith <paul@mad-scientist.net> wrote:
> 
> > coredump: Retry writes where appropriate
> > 
> > Core dump write operations (especially to a pipe) can be incomplete due
> > to signal reception or possibly recoverable partial writes.
> 
> NAK this
> 
> > Previously any incomplete write in the ELF core dumper caused the core
> > dump to stop, giving short cores in these cases.  Modify the core dumper
> > to retry the write where appropriate.
> 
> The existing behaviour is an absolute godsend when you've something like
> a core dump stuck on an NFS mount or something trying to core dump to
> very slow media.
> 
> In fact the signals checks were *purposefully added* some time ago.

Perhaps removing the "|| r == -EINTR" part would make both of you
happy?  He gets the reliability on pipes, you keep the interrupt on
signals.

  OG.
