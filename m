Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXC3Wux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXC3Wux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbXC3Wuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:50:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55618 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXC3Wuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:50:52 -0400
Date: Fri, 30 Mar 2007 15:50:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
Message-Id: <20070330155043.2daa6d5c.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0703301506q17509843h1309a4132634154a@mail.gmail.com>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	<20070330141524.5f6cff29.akpm@linux-foundation.org>
	<b040c32a0703301506q17509843h1309a4132634154a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 15:06:03 -0700
"Ken Chen" <kenchen@google.com> wrote:

> On 3/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > So..  this change will cause a fatal error for anyone who is presently
> > using max_loop, won't it?  If they're doing that within their
> > initramfs/initrd/etc then things could get rather ugly for them.
> 
> probably, if they access loop device non-sequentially.
> 

My point is that the modprobe will fail if it is passed an unrecognised
module parameter (won't it?)

So if we're worried about not breaking existing setups, we should retain
this module parameter as a do-nothing thing, maybe with a
this-is-going-away warning printk, too.

> 
> > I don't know how much of a problem this will be in practice - do people use
> > max_loop much?
> 
> I don't know either.

hm.

> 
> > btw, did you test this change as both a module and as linked-into-vmlinux?
> 
> as linked-into-vmlinux.  why do you ask?  It breaks if it is module?
> I made last minute change to a mutex name and shamely posted without
> doing a compile test.  Besides that, is there something else breaks?

Just idle curiosity regarding how much testing it had seen.

Generally one would expect things to be OK, but there can be startup
ordering problems.

The most common problem is that the module simply doesn't load because it's
using some not-exported-to-modules symbol

