Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZGVTmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZGVTmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZGVTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:42:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbZGVTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:42:13 -0400
Date: Wed, 22 Jul 2009 12:42:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, jsquyres@cisco.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
Message-Id: <20090722124208.97d7d9d7.akpm@linux-foundation.org>
In-Reply-To: <adad47smsb5.fsf@cisco.com>
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
	<adad47smsb5.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 12:27:42 -0700
Roland Dreier <rdreier@cisco.com> wrote:

>  > >  1. ioctl() to register/unregister an address range to watch in the
>  > >     kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).
>  > > 
>  > >  2. read() to retrieve events generated when a mapping in a watched
>  > >     address range is invalidated (cf struct ummunot_event in
>  > >     <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
>  > >     for this IO.
>  > > 
>  > >  3. mmap() one page at offset 0 to map a kernel page that contains a
>  > >     generation counter that is incremented each time an event is
>  > >     generated.  This allows userspace to have a fast path that checks
>  > >     that no events have occurred without a system call.
>  > 
>  > If you stand back and squint, each of 1, 2 and 3 are things which the
>  > kernel already provides for the delivery of ftrace events to userspace.
>  > 
>  > Did you look at reusing all that stuff?
> 
> No, not really... will investigate a bit further.  Any pointers to how
> the ftrace stuff might work?

I know who to cc ;)

>  Specifically how #3 maps to ftrace is a
> little obscure to me; and also as I understand it, ftrace is controlled
> through debugfs, which means there's a bit of hassle to make this usable
> on a default install.  And also I'm not sure how the ftrace control path
> really maps to "here's a 100 address ranges I'd like events for".
> 
> So at a first glance after unsquinting a bit I'm not sure how good the
> fit really is.

Oh.  Here was I hoping that all that code was about to become useful.
<runs away>
