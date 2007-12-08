Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXLHEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXLHEVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLHEU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:20:58 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36784 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXLHEU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:20:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org, den@openvz.org
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<1197067918.10831.13.camel@heimdal.trondhjem.org>
	<20071207151444.af5d8e11.akpm@linux-foundation.org>
	<200712080043.29292.rjw@sisk.pl>
	<20071208000043.GC1951@martell.zuzino.mipt.ru>
	<20071207161508.afe8fdf1.akpm@linux-foundation.org>
Date: Fri, 07 Dec 2007 21:18:57 -0700
In-Reply-To: <20071207161508.afe8fdf1.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 7 Dec 2007 16:15:08 -0800")
Message-ID: <m1prxhq0ni.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> OK, perhaps a revert is the best thing to do here.  I don't think anyone
> will be expecting fully finalised and robust netns support in 2.6.24.

I do think we expect /proc/net when the netns support is disabled
to be as robust as it has been prior to 2.6.24, which is where we came
in.

The problem I tried to close one hole too many with my previous patch.

The simplest thing to do and that will make things work for everyone
in a tried and true fashion is not a complete revert but to simply
remove d_revalidate (which is causing all of the trouble).

We can figure out how to deal with the VFS mount handling not being
friendly to network filesystems  later.  The implementation details of
VFS mount handling do not lest us remove dcache entries for
directories (even when they have been removed from the backing store)
until we have removed all mounts from them and their children.  Since
I violated that rule. Kaboom!

Eric
