Return-Path: <linux-kernel-owner+w=401wt.eu-S1751539AbZGUENz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbZGUENz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZGUENw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:13:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZGUENw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:13:52 -0400
Date: Tue, 21 Jul 2009 00:13:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090721041311.GE11051@bombadil.infradead.org>
References: <1248132223.2654.278.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248132223.2654.278.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 07:23:43PM -0400, Eric Paris wrote:
> With SELinux mapping the 0 page requires an SELinux policy permission,
> mmap_zero.  Without SELinux mapping the 0 page requires CAP_SYS_RAWIO.
> Note that CAP_SYS_RAWIO roughly translates to uid=0 since noone really
> does interesting things with capabilities.
> 
[...]
> I believe (from reading mailing lists) if you install WINE on ubuntu it
> automatically disables these protections.  Thus installing wine on
> ubuntu disables ALL hardening gains of the mmap_min_addr.
> 
[...]
> So on a non-SELinux system users would end up with exactly what they
> have today.  if you want to run WINE as a normal user you have to set
> mmap_min_addr = 0 and then you no longer need CAP_SYS_RAWIO.  Not much
> else we can do if your distro down support fine grained permissions.
> 

Why do we not add a personality flag for this? With that, at least you
could require a harmless setuid wrapper for wine that just set the
personality bits and dropped root.

That at least would allow the people not shipping SELinux by default,
(which, really, is everyone but us, afaik...) to at least avoid having
to whole-sale disable the mmap_min_addr protections, which seems unduly
harsh... (If they're doing this without consulting the user, then, wow,
that's just anti-social...)

Of course, I might be missing the plot entirely here.

(Or, as someone else pointed out, force people to run this crap in a
VM. ;-)

regards, Kyle
