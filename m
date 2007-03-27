Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXC0Vgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXC0Vgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXC0Vgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:36:37 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43916 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965349AbXC0Vgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:36:36 -0400
Date: Tue, 27 Mar 2007 14:36:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-Id: <20070327143629.9c8953db.akpm@linux-foundation.org>
In-Reply-To: <20070327212419.GA5817@ucw.cz>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
	<20070327212419.GA5817@ucw.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 21:24:20 +0000
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> > 
> > These new entries are added:
> > 
> >   /proc/PID/fdinfo/FD
> >   /proc/PID/task/TID/fdinfo/FD
> > 
> > For each fd the information is provided in the following format:
> > 
> > pos:	1234
> > flags:	0100002
> 
> Octal? Maybe we should use more traditional hex here?

Good point.  The O_foo flags are per-arch, so this field has the potential
to be subtly different on different architectures, which is unpleasing.

> Or even list flags by name?

urg.  Simple enough to do (lookup table, please).  But is it worth it? 
Perhaps just remove that field?
