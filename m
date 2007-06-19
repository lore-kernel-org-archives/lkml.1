Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXFSH6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXFSH6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXFSH5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:57:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:54499 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753206AbXFSH5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:57:52 -0400
Date: Tue, 19 Jun 2007 10:11:20 +0200
From: Jan Kara <jack@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Quota netlink interface
Message-ID: <20070619081120.GC18638@duck.suse.cz>
References: <20070618121455.GI9319@duck.suse.cz> <20070618120103.2807b78d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618120103.2807b78d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-06-07 12:01:03, Randy Dunlap wrote:
> On Mon, 18 Jun 2007 14:14:55 +0200 Jan Kara wrote:
> 
> >   Hello,
> > 
> >   I've written a patch implementing quota netlink interface. Whenever some
> > event happens (like user exceeding softlimit), a message is sent to
> > userpace. Then, in userspace we can decide what to do with the message -
> > print it to console, show a dialog or whatever... I've also written a new
> > daemon that listens to netlink and sends the received message to DBus and/or
> > to the console the user has last written to.
> >   If somebody is interested in trying it out, he can checkout latest
> > quota-tools CVS and I can provide him with the modified libnl providing
> > better support for generic netlink handling.
> 
> 
> +config QUOTA_NETLINK_INTERFACE
> +	bool "Report quota messages through netlink interface"
> +	depends on QUOTA
> +	select NET
> +	help
> +	  If you say Y here, quota warnings (about exceeding softlimit, reaching
> +	  hardlimit, etc.) will be reported through netlink interface. If unsure,
> +	  say Y.
> 
> 
> Using "select" is either evil or OK, but only OK for "library-type" code.
> It should never be used to pull in a complete subsystem like NET does
> (even though SCSI_NETLINK does this same thing, sadly).
  OK, I can make it 'depends on NET' instead. I guess it's no problem in
this case since whoever wants quota is going to have NET enabled.
  The problem I sometimes have with 'depends on' is that the option is
invisible until you have enabled all the dependencies so it's hard to
  a) find out that there exists and interesting feature (because it depends
on something you are not used to turn on).
  b) you know the feature exists but you have to dig in Kconfigs to find out
what you have to enable first...

  Maybe we could improve Kconfig to support other type of dependency that
shows you the option even if these dependencies are not satisfied (probably in
some other color) but allows you to only view help and unresolved
dependencies...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
