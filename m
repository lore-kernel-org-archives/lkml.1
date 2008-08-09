Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYHIMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYHIMxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYHIMxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 08:53:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYHIMxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 08:53:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1218281190.3155.5.camel@dhcppc0>
References: <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sat, 09 Aug 2008 13:52:07 +0100
Message-ID: <14476.1218286327@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> wrote:

> > > Beginning with next-20080808 after letting the system run for 5 minutes
> > > or so, I get an error from the fork call, e.g.:
> > > 
> > > "bash: fork: Resource temporarily unavailable"

I modified your config slightly so that it'd run on my testbox (x86_64
unfortunately), but that survived LTP and seemed to work okay.  I'll have to
snag an i386 installation from somewhere, unless James can do me a favour and
test it on his, if he has one.

Can you try this please:

	cat /proc/slabinfo  | cut -d: -f1 | sort -k 2 -n

Just to check to see if there's a memory leak.

Interestingly, I notice that SLUB's /proc/slabinfo appears to be broken.  It's
missing a number of slab caches from the list.

David
