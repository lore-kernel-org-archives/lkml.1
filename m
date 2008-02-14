Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbYBNRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbYBNRk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYBNRkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:40:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54391 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbYBNRkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:40:12 -0500
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, menage@google.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1203006419.8343.48.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Thu, 14 Feb 2008 11:26:59 -0500)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu> <1203006419.8343.48.camel@heimdal.trondhjem.org>
Message-Id: <E1JPi3u-0002rp-Nz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 18:39:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And I'm not against doing it with the "at*" variants, as Trond
> > suggested.
> 
> If you're going to change the syscall, then you should ensure that it
> solves _all_ the problems that are known at this time. Ignoring the
> automounter issue is just going to force us to redo the syscall in a
> couple of months...

Sure.

Although, an (almost) equivalent userspace code would be:

mount_fooat(int fd, const char *path)
{
	char tmpbuf[64];
	int tmpfd = openat(fd, path);

	sprintf(tmpbuf, "/proc/self/fd/%i", tmpfd);
	return mount_foo(tmpbuf, ...);
}

Or is there something (other than not requiring proc) that the *at
variant gives?

Miklos

