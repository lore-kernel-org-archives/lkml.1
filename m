Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXA1PZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXA1PZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXA1PZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:25:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:20510 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXA1PZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DrYozaGmvGa7uTOl4V5J7FjMcZgkPrJ4+1F6GYt1wQGv1Us599aU/gySPZ9VJd594TUI/Xup/+ipdeipjLtg3zlvf4AgOwHFLWcQmWLRIr/s7YrTrqQcbxr/bnLgxYLc+Qz2CLCQHZGZuq1lRRSxrJOiY7HEgD5f9C1PE0T0db8=
Date: Sun, 28 Jan 2007 18:24:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] lutimesat: simplify utime(2)
Message-ID: <20070128152459.GA5549@martell.zuzino.mipt.ru>
References: <20070126112142.GA11128@localhost.sw.ru> <20070126124120.f8f78623.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126124120.f8f78623.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:41:20PM -0800, Andrew Morton wrote:
> On Fri, 26 Jan 2007 14:21:42 +0300
> Alexey Dobriyan <adobriyan@openvz.org> wrote:
> 
> > Rewrite via do_utimes() like compat_sys_utime().
> 
> I'm somewhat surprised that this wasn't done earlier.

Because, the following patch didn't hit -mm. :)

	From adobriyan@gmail.com Wed Oct 25 20:32:24 2006
	Date: Wed, 25 Oct 2006 20:32:24 +0400
	From: Alexey Dobriyan <adobriyan@gmail.com>
	To: Andrew Morton <akpm@osdl.org>
	Cc: linux-kernel@vger.kernel.org
	Subject: [PATCH] Shrink sys_utime()
	Message-ID: <20061025163224.GA5356@martell.zuzino.mipt.ru>
	Mime-Version: 1.0
	Content-Type: text/plain; charset=us-ascii
	Content-Disposition: inline
	User-Agent: Mutt/1.5.11
	Status: RO
	Content-Length: 3314
	Lines: 118

	All checks in sys_utime() and do_utimes() are duplicated as well as a
	comment. sys_utime() will now use do_utimes() after getting times from
	userspace and projecting them to struct timeval [2].

Nevermind.

> I wonder if there's some subtle reason why this won't work.

I don't know. Compat syscall -- I'm not touching it. Normal syscall --
time_t is long on all archs, suseconds_t is sometimes int, but we're
putting zero there.

> How well tested is this?

It passed utime tests in December's LTP.

