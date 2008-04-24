Return-Path: <linux-kernel-owner+w=401wt.eu-S1764548AbYDXPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764548AbYDXPpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbYDXPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:45:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbYDXPpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:45:25 -0400
Date: Thu, 24 Apr 2008 11:44:41 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424154441.GG2255@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com> <20080424112514.055d8071@the-village.bc.nu> <481096C3.2020206@redhat.com> <20080424152436.6cf53c1b@the-village.bc.nu> <4810A46B.1090809@redhat.com> <20080424160352.30f2dd5b@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424160352.30f2dd5b@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:03:52PM +0100, Alan Cox wrote:
> > > Every other property of a socket via accept() is inherited from the
> > > parent. Making one property different would be bizarre and ugly.
> > 
> > Implementing this would visibly change existing code and it would
> > actively violate POSIX.  Not a good idea.
> 
> POSIX has no interface for this new behaviour you propose so that is
> complete crap. The moment you use one of these features you stepped
> outside of the POSIX spec - and you know that. If there was an existing
> standard we wouldn't have a problem.

Doing:

int fd = socket (PF_INET, SOCK_STREAM, 0);
fcntl (fd, F_SETFD, F_CLOEXEC);
...
int fd2 = accept (fd, addr, addrlen);

certainly doesn't use any of the new interfaces, yet if accept inherits
the CLOEXEC flag from the socket, would visibly change existing programs.

	Jakub
