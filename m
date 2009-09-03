Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZICWWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZICWWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbZICWWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:22:53 -0400
Received: from newpeace.netnation.com ([204.174.223.7]:57230 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932370AbZICWWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:52 -0400
Date: Thu, 3 Sep 2009 15:22:53 -0700
From: Simon Kirby <sim@hostway.ca>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yohan <ytordjman@corp.free.fr>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       mikevs@xs4all.net
Subject: Re: VM issue causing high CPU loads
Message-ID: <20090903222253.GA8405@hostway.ca>
References: <4A92A25A.4050608@yohan.staff.proxad.net> <20090824162155.ce323f08.akpm@linux-foundation.org> <4A96463E.5080002@corp.free.fr> <4A9C34F8.2010307@corp.free.fr> <20090902170642.f4381c1d.akpm@linux-foundation.org> <1251982884.18338.9.camel@heimdal.trondhjem.org> <4A9FC719.9020104@corp.free.fr> <1251986526.18338.29.camel@heimdal.trondhjem.org> <20090903200550.GB5257@hostway.ca> <1252010965.18338.63.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252010965.18338.63.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 04:49:25PM -0400, Trond Myklebust wrote:

> I'm working on increasing the idmapper scalability, however another
> project is currently taking up most of my time. I can't guarantee that
> the revised idmapper code will be finished in time to allow for
> inclusion in 2.6.32.

Sure, improving it would be nice for cases where it's needed, but in
environments where all IDs are consistent (by design), it just seems
silly to force this extra work for zero gain.

> NFSv4 aspires to be an internet-wide protocol, and so you cannot use
> uids/gids: they just aren't guaranteed to represent a unique user
> outside your local LDAP/NIS or /etc/passwd domain. Furthermore, uids and
> gids are a posix construct. They simply don't work in environments where
> you may have lots of non-posix systems.

So, for environments with all POSIX systems, what do you think about
perhaps a mount or export flag that violates the spec on purpose to allow
numeric IDs to be used?

I can understand that the quiet use of IDs if name-to-user mapping fails
will cause security issues in environments without consistent users, so
it would now be unsafe to turn this on silently.  However, making this
an option seems reasonable to me.

(Not that I know what I'm doing.)

Simon-
