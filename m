Return-Path: <linux-kernel-owner+w=401wt.eu-S966135AbXDCAkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966135AbXDCAkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966136AbXDCAkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:40:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966135AbXDCAkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:40:35 -0400
Date: Mon, 2 Apr 2007 17:40:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "kalash nainwal" <kalash.nainwal@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (re)register_binfmt returns with -EBUSY
Message-Id: <20070402174033.ec74aa5b.akpm@linux-foundation.org>
In-Reply-To: <416aa1ad0704020554u54ec3720oe99eba180ffa11eb@mail.gmail.com>
References: <416aa1ad0704020554u54ec3720oe99eba180ffa11eb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 18:24:15 +0530
"kalash nainwal" <kalash.nainwal@gmail.com> wrote:

> When a binary format is unregistered and re-registered,
> register_binfmt fails with -EBUSY. The reason is that
> unregister_binfmt does not set fmt->next to NULL, and seeing
> (fmt->next != NULL), register_binfmt fails with -EBUSY.
> 
> One can find his way around by explicitly setting fmt->next to NULL
> after unregistering, but that is kind of unclean (one should better be
> using only the interfaces, and not the interal members, isn't it?)
> 
> Attached one-liner can fix it (for 2.6.20).

Yes, that'll fix it.

But I wonder why register_binfmt() even checks that the to-be-registered
linux_binfmt has a non-null fmt->next?  Presumably that's there to catch
erroneous re-registration of an already-registered format.

All very odd.  It looks like that code should be converted to list_heads
anyway...
