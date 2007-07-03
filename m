Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXGCNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXGCNBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXGCNBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:01:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbXGCNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:01:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:08:45 +0200
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <1183441887.10386.77.camel@localhost.localdomain>
In-Reply-To: <1183441887.10386.77.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031508.45595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 07:51, Benjamin Herrenschmidt wrote:
> On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > a screaming nightmare - either the suspend fails because syslog (for 
> > instance) can't be frozen, or the machine deadlocks for some other 
> > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > and just not use the freezer.
> 
> The main reason for deadlocks is because we do a sys_sync() after the
> freeze, which we shouldn't do.

So why don't we remove the sys_sync() from freeze_processes() instead?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
