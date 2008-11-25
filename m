Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYKYJ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYKYJ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKYJ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:26:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49565 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYKYJ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:26:42 -0500
Subject: Re: [PATCH][V4]Make get_user_pages interruptible
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, akpm <akpm@linux-foundation.org>
In-Reply-To: <604427e00811241521t3e75650ft48bc60cdfb16df0e@mail.gmail.com>
References: <604427e00811241521t3e75650ft48bc60cdfb16df0e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Nov 2008 11:28:20 +0200
Message-Id: <1227605300.1566.17.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 15:21 -0800, Ying Han wrote:
> From: Ying Han <yinghan@google.com>
> 
> make get_user_pages interruptible
> The initial implementation of checking TIF_MEMDIE covers the cases of OOM
> killing. If the process has been OOM killed, the TIF_MEMDIE is set and it
> return immediately. This patch includes:
> 
> 1. add the case that the SIGKILL is sent by user processes. The process can
> try to get_user_pages() unlimited memory even if a user process has sent a
> SIGKILL to it(maybe a monitor find the process exceed its memory limit and
> try to kill it). In the old implementation, the SIGKILL won't be handled
> until the get_user_pages() returns.
> 
> 2. change the return value to be ERESTARTSYS. It makes no sense to return
> ENOMEM if the get_user_pages returned by getting a SIGKILL signal.
> Considering the general convention for a system call interrupted by a
> signal is ERESTARTNOSYS, so the current return value is consistant to that.

Looks good to me (but I'm not the maintainer of this particular piece of
code).

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

﻿You might want to add an explanation why we check both 'tsk' and
'current' in either in the patch description or as a comment, though. Or
just add a link to the mailing list archives in the description or
something.

> Signed-off-by:	Paul Menage <menage@google.com>
> Singed-off-by:	Ying Han <yinghan@google.com>
  ^^^^^^

I'm sure you have a beautiful singing voice but from legal point of
view, it's probably better to just sign it off. ;-)

			Pekka

